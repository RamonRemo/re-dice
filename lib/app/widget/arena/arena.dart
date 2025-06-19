import 'package:flutter/material.dart';
import 'package:re_dice/app/utils/constants.dart';

class Arena extends StatelessWidget {
  final double left;
  final double top;
  final double width;
  final double height;

  const Arena({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: width,
        height: height,
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
