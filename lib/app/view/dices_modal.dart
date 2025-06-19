import 'package:flutter/material.dart';
import 'package:re_dice/app/models/dice.dart';
import 'package:re_dice/app/utils/constants.dart';
import 'package:re_dice/app/widget/dice_chip.dart';

class DiceSelectionModal extends StatelessWidget {
  final List<Dice> diceList;
  final Function(int sides) onAddDice;
  final Function(Dice dice) onRemoveDice;
  final VoidCallback onReset;

  const DiceSelectionModal({
    super.key,
    required this.diceList,
    required this.onAddDice,
    required this.onRemoveDice,
    required this.onReset,
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Constants.matrixGreen, width: 2),
          left: BorderSide(color: Constants.matrixGreen, width: 2),
          right: BorderSide(color: Constants.matrixGreen, width: 2),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  'Dice Selection',
                  style: TextStyle(color: Constants.matrixGreen, fontSize: 30),
                ),
                Spacer(),
                IconButton(
                  onPressed: onReset,
                  icon: Icon(
                    Icons.refresh,
                    color: Constants.matrixGreen,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Reset button
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
                      onRemoveDice: () {},
                      onAddDice: (sides) => onAddDice(sides),
                      sides: sides,
                    );
                  }).toList(),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
