import 'package:flutter/material.dart';
import 'package:re_dice/app/controllers/arena_controller.dart';
import 'package:re_dice/app/controllers/dice_animation_controller.dart';
import 'package:re_dice/app/models/dice.dart';
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

  // Widget visual para dados
  Widget buildDiceWidget(int sides, int value) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Constants.primary, width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Center(
        child:
            sides == 6
                ? _buildD6Dots(value)
                : Text(
                  '$value',
                  style: TextStyle(
                    color: Constants.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  Widget _buildD6Dots(int value) {
    return GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(4),
      children: List.generate(9, (index) {
        bool showDot = _shouldShowDot(value, index);
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: showDot ? Constants.primary : Colors.transparent,
          ),
          width: 8,
          height: 8,
        );
      }),
    );
  }

  bool _shouldShowDot(int value, int position) {
    // Posições: 0,1,2 (top), 3,4,5 (middle), 6,7,8 (bottom)
    switch (value) {
      case 1:
        return position == 4; // center
      case 2:
        return position == 0 || position == 8; // top-left, bottom-right
      case 3:
        return position == 0 || position == 4 || position == 8; // diagonal
      case 4:
        return position == 0 ||
            position == 2 ||
            position == 6 ||
            position == 8; // corners
      case 5:
        return position == 0 ||
            position == 2 ||
            position == 4 ||
            position == 6 ||
            position == 8; // corners + center
      case 6:
        return position == 0 ||
            position == 2 ||
            position == 3 ||
            position == 5 ||
            position == 6 ||
            position == 8; // sides
      default:
        return false;
    }
  }

  List<Widget> renderDice() {
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
          child: buildDiceWidget(dice.sides, dice.selectedValue),
        ),
      );
    }).toList();
  }
}
