import 'package:flutter/material.dart';
import 'package:re_dice/app/controllers/arena_controller.dart';
import 'package:re_dice/app/controllers/dice_animation_controller.dart';
import 'package:re_dice/app/models/dice.dart';
import 'package:re_dice/app/utils/constants.dart';
import 'package:re_dice/app/widget/dice/standard/dot_logic.dart';
import 'dart:math' as math;

class DiceRenderer {
  final ArenaController arenaController;
  final List<Dice> diceList;
  final DiceAnimationController animationController;

  DiceRenderer({
    required this.arenaController,
    required this.diceList,
    required this.animationController,
  });

  // Método para calcular o tamanho dos dados com base na quantidade
  double calculateDiceSize(int diceCount) {
    const double baseSize = 60.0; // Tamanho base
    if (diceCount <= 5) {
      return baseSize;
    } else {
      double newSize =
          baseSize - ((diceCount - 5) * 3.0); // Reduz tamanho mais suavemente
      return math.max(newSize, 40.0); // Tamanho mínimo ajustado
    }
  }

  // Widget visual para dados
  Widget buildDiceWidget(int sides, int value, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Constants.primary, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Constants.background,
      ),
      child: Center(
        child:
            sides == 6
                ? D6Dots(value: value)
                : Text(
                  '$value',
                  style: TextStyle(
                    color: Constants.primary,
                    fontSize: size / 3, // Ajusta tamanho da fonte
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  List<Widget> renderDice() {
    double diceSize = calculateDiceSize(diceList.length);

    return animationController.dicePositions.asMap().entries.map((entry) {
      int i = entry.key;
      var pos = entry.value;
      Dice dice = diceList[i];

      return Positioned(
        // Position dice relative to the arena
        left: arenaController.arenaLeft + (pos.x * arenaController.arenaWidth),
        top: arenaController.arenaTop + (pos.y * arenaController.arenaHeight),
        child: Container(
          transform: Matrix4.rotationZ(pos.rotation),
          child: buildDiceWidget(dice.sides, dice.selectedValue, diceSize),
        ),
      );
    }).toList();
  }
}
