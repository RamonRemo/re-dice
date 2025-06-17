
import 'package:flutter/material.dart';
import 'package:re_dice/app/utils/constants.dart';

class DiceChip extends StatelessWidget {
  final int count;
  final Function(int sides) onAddDice;
  final Function() onRemoveDice;
  final int sides;

  const DiceChip({
    super.key,
    required this.count,
    required this.onAddDice,
    required this.onRemoveDice,
    required this.sides,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.matrixGreen),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Only show remove button if we have dice of this type
          if (count > 0)
            GestureDetector(
              onTap: onRemoveDice,
              child: Text(
                ' - ',
                style: TextStyle(
                  color: Constants.matrixGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Show the dice count and type
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              count > 0 ? '$count d$sides' : 'd$sides',
              style: TextStyle(color: Constants.matrixGreen, fontSize: 18),
            ),
          ),

          // Add button
          GestureDetector(
            onTap: () => onAddDice(sides),
            child: Text(
              ' + ',
              style: TextStyle(
                color: Constants.matrixGreen,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
