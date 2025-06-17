import 'package:re_dice/app/model/dice.dart';

class DiceDto {
  final int id;
  final int sides;
  int selectedValue;

  DiceDto({this.id = 0, this.sides = 6, this.selectedValue = 1});

  Dice toBox() {
    return Dice(id: id, sides: sides, selectedValue: selectedValue);
  }

  DiceDto.fromBox(Dice dice)
      : id = dice.id,
        sides = dice.sides,
        selectedValue = dice.selectedValue;
}


