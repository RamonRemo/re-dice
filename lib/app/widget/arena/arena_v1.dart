import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:re_dice/app/utils/constants.dart';

class ArenaV1 extends StatelessWidget {
  final double left;
  final double top;
  final double width;
  final double height;

  const ArenaV1({
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
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: Constants.primary,
        strokeWidth: 6,
        dashPattern: [3, 18],
        child: Container(width: width, height: height, color: Colors.black),
      ),
    );
  }
}
