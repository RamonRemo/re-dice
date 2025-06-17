import 'package:flutter/material.dart';
import 'package:re_dice/app/utils/constants.dart';

class Arena extends StatelessWidget {
  final double arenaLeft;
  final double arenaTop;
  final double arenaWidth;
  final double arenaHeight;

  const Arena({
    super.key,
    required this.arenaLeft,
    required this.arenaTop,
    required this.arenaWidth,
    required this.arenaHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: arenaLeft,
      top: arenaTop,
      child: Container(
        width: arenaWidth,
        height: arenaHeight,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Constants.matrixGreen, width: 3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Constants.matrixGreen.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
