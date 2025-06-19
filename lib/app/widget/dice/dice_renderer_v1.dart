import 'package:flutter/material.dart';
import 'package:re_dice/app/controllers/arena_controller.dart';
import 'package:re_dice/app/controllers/dice_animation_controller.dart';
import 'package:re_dice/app/models/dice.dart';
import 'package:re_dice/app/utils/constants.dart';
import 'dart:math' as math;

class DiceRendererv1 {
  final ArenaController arenaController;
  final List<Dice> diceList;
  final DiceAnimationController animationController;

  DiceRendererv1({
    required this.arenaController,
    required this.diceList,
    required this.animationController,
  });

  // ASCII representations for dice faces
  String getAsciiFace(int sides, int value) {
    if (sides == 6) {
      switch (value) {
        case 1:
          return '''
+-------+
|       |
|   o   |
|       |
+-------+''';
        case 2:
          return '''
+-------+
| o     |
|       |
|     o |
+-------+''';
        case 3:
          return '''
+-------+
| o     |
|   o   |
|     o |
+-------+''';
        case 4:
          return '''
+-------+
| o   o |
|       |
| o   o |
+-------+''';
        case 5:
          return '''
+-------+
| o   o |
|   o   |
| o   o |
+-------+''';
        case 6:
          return '''
+-------+
| o   o |
| o   o |
| o   o |
+-------+''';
        default:
          return '[$value]';
      }
    }

    // For other dice types, just show the value
    return '''
+-------+
|       |
|  ${getDiceValue(value)}  |
|       |
+-------+''';
  }

  String getDiceValue(value) {
    if (value > 10 && value < 100) {
      return '$value ';
    }

    if (value < 10) {
      return ' $value ';
    }

    return '$value';
  }

  List<Widget> renderDice() {
    // Calculate font size based on number of dice
    double fontSize = calculateFontSize(diceList.length);

    return animationController.dicePositions.asMap().entries.map((entry) {
      int i = entry.key;
      var pos = entry.value;
      Dice dice = diceList[i];
      String asciiDice = getAsciiFace(dice.sides, dice.selectedValue);

      return Positioned(
        // Position dice relative to the arena
        left: arenaController.arenaLeft + (pos.x * arenaController.arenaWidth),
        top: arenaController.arenaTop + (pos.y * arenaController.arenaHeight),
        child: Container(
          transform: Matrix4.rotationZ(pos.rotation),
          child: Text(
            asciiDice,
            style: TextStyle(
              fontFamily: 'Courier', // Monospace font for proper alignment
              fontSize: fontSize, // Use the dynamic font size
              color: Constants.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList();
  }

  // Helper method to calculate font size based on dice count
  double calculateFontSize(int diceCount) {
    // Start with a base size
    const double baseSize = 14.0;

    // For each die beyond 5, reduce size
    if (diceCount <= 5) {
      return baseSize;
    } else {
      // Decrease size for each additional die
      double newSize = baseSize - ((diceCount - 5) * 1.0);

      // Don't let it get too small
      return math.max(newSize, 6.0);
    }
  }
}
