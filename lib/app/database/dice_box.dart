import 'package:objectbox/objectbox.dart';
import 'package:re_dice/app/model/dice_copy.dart';
import 'package:re_dice/app/model/dice.dart';

class DiceBox {
  final Store store;

  DiceBox(this.store);

  int create(DiceDto dice) {
    final temp = dice.toBox();

    return store.box<Dice>().put(temp, mode: PutMode.insert);
  }

  void delete(DiceDto dice) {
    store.box<Dice>().remove(dice.id);
  }

  List<DiceDto> getAll() {
    final dices = store.box<Dice>().getAll();
    return dices.map((dice) => DiceDto.fromBox(dice)).toList();
  }
}
