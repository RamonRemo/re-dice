import 'package:flutter/material.dart';

class Constants {
  // Verde Matrix clássico (mais brilhante)
  static Color primary = _getRandomColor();
  static const Color background = Colors.black;

  static final List<Color> _availableColors = [
    Color(0xFF00FF41), // Matrix Green
    Color(0xFF00D4FF), // Cyber Blue
    Color(0xFFBF00FF), // Neon Purple
    Color(0xFFFF4500), // Fire Orange
    Color(0xFFFFFF00), // Electric Yellow
    Color(0xFFDC143C), // Deep Red
    Color(0xFF20B2AA), // Ocean Teal
    Color(0xFF00FFB3), // Mint Green
    Color(0xFF7B68EE), // Royal Purple
    Color(0xFFFF1493), // Hot Pink
    Color(0xFF32CD32), // Lime Green
    Color(0xFFFFD700), // Golden Yellow
    Color(0xFF87CEEB), // Ice Blue
    Color(0xFF8A2BE2), // Violet
    Color(0xFFFF7F50), // Coral
    Color(0xFF50C878), // Emerald
    Color(0xFFFF00FF), // Magenta
    Color(0xFF40E0D0), // Turquoise
    Color(0xFFFFBF00), // Amber
    Color(0xFF4682B4), // Steel Blue
    Colors.white,
  ];

  // Método para obter uma cor aleatória
  static Color _getRandomColor() {
    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % _availableColors.length;
    return _availableColors[randomIndex];
  }

  // Método para atualizar a cor atual
  static void updateColor() {
    primary = _getRandomColor();
  }
}
