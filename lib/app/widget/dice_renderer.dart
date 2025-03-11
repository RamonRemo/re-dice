import 'package:flutter/material.dart';
import 'package:re_dice/app/controllers/arena_controller.dart';
import 'package:re_dice/app/controllers/dice_animation_controller.dart';
import 'package:re_dice/app/model/dice.dart';
import 'package:re_dice/app/utils/constants.dart';

class DiceRenderer {
  final ArenaController arenaController;
  final List<Dice> diceList;
  final DiceAnimationController animationController;

  DiceRenderer({
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
              fontSize: 10,
              color: Constants.matrixGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList();
  }
}
