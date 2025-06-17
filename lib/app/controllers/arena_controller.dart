import 'package:flutter/material.dart';
import 'package:re_dice/app/utils/constants.dart';
// import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';

class ArenaController {
  late double arenaWidth;
  late double arenaHeight;
  late double arenaLeft;
  late double arenaTop;

  void updateDimensions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Limitar tamanho da arena para web
    if (kIsWeb) {
      arenaWidth = (screenWidth * 0.9).clamp(300, 800);
      arenaHeight = (screenHeight * 0.6).clamp(200, 500);
    } else {
      arenaWidth = screenWidth * 0.9;
      arenaHeight = screenHeight * 0.6;
    }

    arenaLeft = (MediaQuery.of(context).size.width - arenaWidth) / 2;
    arenaTop = (MediaQuery.of(context).size.height - arenaHeight) / 2.4;
  }

  Widget buildArena() {
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
