import 'package:flutter/material.dart';
import 'package:re_dice/app/model/dice.dart';
import 'package:re_dice/app/utils/constants.dart';

class DiceSelectionModal extends StatelessWidget {
  final List<Dice> diceList;
  final Function(int sides) onAddDice;
  final Function(Dice dice) onRemoveDice;

  const DiceSelectionModal({
    super.key,
    required this.diceList,
    required this.onAddDice,
    required this.onRemoveDice,
  });

  @override
  Widget build(BuildContext context) {
    // List of all available dice types
    final List<int> availableDiceTypes = [4, 6, 8, 10, 12, 16, 20, 24, 100];

    // Get current dice counts grouped by sides
    final Map<int, int> diceGroups = diceList.groupByType();

    // Split dice into existing and non-existing groups
    final List<int> existingDiceTypes = [];
    final List<int> nonExistingDiceTypes = [];

    for (int sides in availableDiceTypes) {
      if ((diceGroups[sides] ?? 0) > 0) {
        existingDiceTypes.add(sides);
      } else {
        nonExistingDiceTypes.add(sides);
      }
    }

    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Constants.matrixGreen, width: 2),
          left: BorderSide(color: Constants.matrixGreen, width: 2),
          right: BorderSide(color: Constants.matrixGreen, width: 2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Dice Selection',
            style: TextStyle(color: Constants.matrixGreen, fontSize: 30),
          ),
          SizedBox(height: 20),

          // Existing dice section (only show if there are any)
          if (existingDiceTypes.isNotEmpty) ...[
            Text(
              'Current Dice',
              style: TextStyle(color: Constants.matrixGreen, fontSize: 18),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children:
                  existingDiceTypes.map((sides) {
                    final count = diceGroups[sides] ?? 0;
                    return DiceChip(
                      count: count,
                      onRemoveDice: () {
                        final diceToRemove = diceList.lastWhere(
                          (d) => d.sides == sides,
                        );
                        onRemoveDice(diceToRemove);
                      },
                      onAddDice: (sides) => onAddDice(sides),
                      sides: sides,
                    );
                  }).toList(),
            ),

            // Divider between sections
            if (nonExistingDiceTypes.isNotEmpty) ...[
              SizedBox(height: 16),
              Divider(
                color: Constants.matrixGreen.withOpacity(0.5),
                thickness: 1,
              ),
              SizedBox(height: 16),
              Text(
                'Available Dice',
                style: TextStyle(color: Constants.matrixGreen, fontSize: 18),
              ),
              SizedBox(height: 10),
            ],
          ],

          // Non-existing dice section
          Wrap(
            spacing: 12,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children:
            
                nonExistingDiceTypes.map((sides) {
                  return DiceChip(
                    count: 0,
                    onRemoveDice:
                        () {},
                    onAddDice: (sides) => onAddDice(sides),
                    sides: sides,
                  );
                }).toList(),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

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
