import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:re_dice/app/utils/constants.dart';

class ArenaV1 extends StatelessWidget {
  final double arenaLeft;
  final double arenaTop;
  final double arenaWidth;
  final double arenaHeight;

  const ArenaV1({
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
      child: DottedBorder(
        borderType: BorderType.RRect,
        // radius: Radius.circular(12),
        color: Constants.matrixGreen,
        strokeWidth: 6,

        // strokeCap: StrokeCap.round,
        dashPattern: [3, 18], // Ajuste o padrão dos pontos conforme necessário
        child: Container(
          width: arenaWidth,
          height: arenaHeight,
          color: Colors.black,
        ),
      ),
    );
  }
}
