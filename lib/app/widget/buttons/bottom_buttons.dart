import 'package:flutter/material.dart';
import 'package:re_dice/app/utils/constants.dart';
import 'package:re_dice/app/widget/buttons/matrix_button.dart';

class BottomButtons extends StatelessWidget {
  final Function() rollFunction;
  final Function() dicesFunction;
  final Function() historyFunction;

  const BottomButtons({
    super.key,
    required this.rollFunction,
    required this.dicesFunction,
    required this.historyFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MatrixButton(onPressed: rollFunction, label: 'Roll'),
          Text('|'),
          MatrixButton(onPressed: dicesFunction, label: 'Dices'),
          Text('|'),
          MatrixButton(onPressed: historyFunction, label: 'History'),
        ],
      ),
    );
  }
}
