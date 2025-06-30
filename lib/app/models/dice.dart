import 'dart:math';

class Dice {
  final int sides;
  final int id;
  int selectedValue;

  Dice({required this.id, this.sides = 6, this.selectedValue = 1});

  int roll() {
    selectedValue = Random().nextInt(sides) + 1;
    return selectedValue;
  }
}

extension DiceListExtension on List<Dice> {
  int rollAll() {
    int total = 0;
    for (final Dice dice in this) {
      total += dice.roll();
    }
    return total;
    
  }

  Map<int, int> groupByType() {
    final Map<int, int> diceCount = {};

    for (var dice in this) {
      diceCount[dice.sides] = (diceCount[dice.sides] ?? 0) + 1;
    }

    // Sort the map by number of sides
    final sortedEntries =
        diceCount.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return Map.fromEntries(sortedEntries);
  }
}
