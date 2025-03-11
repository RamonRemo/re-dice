import 'dart:math';

class Dice {
  final int sides;
  final int id;
  int selectedValue;

  Dice({required this.id, this.sides = 6, this.selectedValue = 1});

  int roll() {
    selectedValue = Random().nextInt(sides) + 1;
    print('Dice $id rolled: $selectedValue');
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
}
