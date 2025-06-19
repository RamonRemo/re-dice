import 'package:flutter/material.dart';
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

    arenaLeft = (screenWidth - arenaWidth) / 2;
    arenaTop = (screenHeight - arenaHeight) / 2.4;
  }

  // Métodos helper para lógica da arena
  bool isInsideArena(double x, double y) {
    return x >= arenaLeft &&
        x <= arenaLeft + arenaWidth &&
        y >= arenaTop &&
        y <= arenaTop + arenaHeight;
  }
}
