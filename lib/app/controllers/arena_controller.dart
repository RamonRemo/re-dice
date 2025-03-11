import 'package:flutter/material.dart';
import 'package:re_dice/app/utils/constants.dart';
import 'package:dotted_border/dotted_border.dart';

class ArenaController {
  late double arenaWidth;
  late double arenaHeight;
  late double arenaLeft;
  late double arenaTop;

  void updateDimensions(BuildContext context) {
    arenaWidth = MediaQuery.of(context).size.width * 0.9;
    arenaHeight = MediaQuery.of(context).size.height * 0.6;
    arenaLeft = (MediaQuery.of(context).size.width - arenaWidth) / 2;
    arenaTop = (MediaQuery.of(context).size.height - arenaHeight) / 3;
  }

  Widget buildArena() {
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
