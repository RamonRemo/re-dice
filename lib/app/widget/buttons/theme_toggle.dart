import 'package:flutter/material.dart';
import 'package:re_dice/app/models/visual_theme.dart';
import 'package:re_dice/app/services/theme_service.dart';
import 'package:re_dice/app/utils/constants.dart';

class ThemeToggle extends StatelessWidget {
  final Function()? onTap;
  const ThemeToggle({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Constants.primary, width: 2),
          color: Constants.background,
        ),
        child: Center(
          child: Text(
            ThemeService.currentTheme == VisualTheme.modern ? 'v1' : 'v0',
            style: TextStyle(
              color: Constants.primary,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
