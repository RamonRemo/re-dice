import 'package:flutter/material.dart';
import 'package:re_dice/app/controllers/arena_controller.dart';
import 'dart:math';
import 'package:re_dice/app/model/dice.dart';

class DicePosition {
  double x, y; // Position (0-1 range for relative positioning)
  double dx, dy; // Velocity
  double rotation = 0.0; // Rotation in radians

  DicePosition({
    required this.x,
    required this.y,
    this.dx = 0,
    this.dy = 0,
    this.rotation = 0.0,
  });
}

class DiceAnimationController {
  final List<Dice> diceList;
  final List<DicePosition> dicePositions = [];
  final Random random = Random();
  late AnimationController animationController;
  final ArenaController arenaController;
  final Function(void Function()) setState;

  DiceAnimationController({
    required this.diceList,
    required TickerProvider vsync,
    required this.arenaController,
    required this.setState,
  }) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );

    resetDicePositions();
    animationController.addListener(_updateDicePositions);
  }

  void resetDicePositions() {
    dicePositions.clear();
    for (int i = 0; i < diceList.length; i++) {
      dicePositions.add(
        DicePosition(
          x: 0.1 + random.nextDouble() * 0.8,
          y: 0.1 + random.nextDouble() * 0.8,
          dx: random.nextDouble() * 0.1 - 0.05,
          dy: random.nextDouble() * 0.1 - 0.05,
        ),
      );
    }
  }

  void startAnimation() {
    // Apply random velocities to dice
    for (var pos in dicePositions) {
      pos.dx = (random.nextDouble() * 0.2) - 0.1;
      pos.dy = (random.nextDouble() * 0.2) - 0.1;
    }

    // Start or restart animation
    animationController.reset();
    animationController.repeat();
  }

  void _updateDicePositions() {
    if (!animationController.isAnimating) return;

    setState(() {
      // Move each die and handle collisions
      for (int i = 0; i < dicePositions.length; i++) {
        var pos = dicePositions[i];

        // Update position with current velocity
        pos.x += pos.dx;
        pos.y += pos.dy;
        pos.rotation += (pos.dx + pos.dy) / 5;

        // Better measurement of dice size
        double diceSizePixels = 64;
        double diceRelativeWidth = diceSizePixels / arenaController.arenaWidth;
        double diceRelativeHeight =
            diceSizePixels / arenaController.arenaHeight;

        // Bounds should be 0.0 to 1.0 for the dice's center point
        if (pos.x < 0.0) {
          pos.x = 0.0;
          pos.dx *= -0.8;
        } else if (pos.x > (1.0 - diceRelativeWidth)) {
          pos.x = 1.0 - diceRelativeWidth;
          pos.dx *= -0.8;
        }

        if (pos.y < 0.0) {
          pos.y = 0.0;
          pos.dy *= -0.8;
        } else if (pos.y > (1.0 - diceRelativeHeight)) {
          pos.y = 1.0 - diceRelativeHeight;
          pos.dy *= -0.8;
        }

        // Simple friction
        pos.dx *= 0.95;
        pos.dy *= 0.95;
      }

      // Collision detection between dice
      for (int i = 0; i < dicePositions.length; i++) {
        for (int j = i + 1; j < dicePositions.length; j++) {
          var pos1 = dicePositions[i];
          var pos2 = dicePositions[j];

          double dx = pos1.x - pos2.x;
          double dy = pos1.y - pos2.y;
          double distance = sqrt(dx * dx + dy * dy);

          // If dice are too close, make them bounce off each other
          if (distance < 0.15) {
            // Calculate collision response
            double angle = atan2(dy, dx);
            double magnitude = 0.02;

            pos1.dx += cos(angle) * magnitude;
            pos1.dy += sin(angle) * magnitude;
            pos2.dx -= cos(angle) * magnitude;
            pos2.dy -= sin(angle) * magnitude;
          }
        }
      }
    });
  }

  void dispose() {
    animationController.dispose();
  }
}
