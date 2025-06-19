import 'package:flutter/material.dart';
import 'package:re_dice/app/utils/constants.dart';

class TotalWidget extends StatelessWidget {
  final String total;
  final List<Widget> diceList;

  const TotalWidget({super.key, required this.total, required this.diceList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Text(
              total,
              style: TextStyle(fontSize: 40, color: Constants.matrixGreen),
            ),
            _DiceList(diceList: diceList),
          ],
        ),
      ),
    );
  }
}

class _DiceList extends StatelessWidget {
  final List<Widget> diceList;
  const _DiceList({super.key, required this.diceList});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, children: diceList);
  }
}
