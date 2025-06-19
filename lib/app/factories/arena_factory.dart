import 'package:flutter/material.dart';

import 'package:re_dice/app/models/visual_theme.dart';
import 'package:re_dice/app/services/theme_service.dart';
import 'package:re_dice/app/widget/arena/arena.dart';
import 'package:re_dice/app/widget/arena/arena_v1.dart';

class ArenaFactory {
  static Widget createArena({
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    switch (ThemeService.currentTheme) {
      case VisualTheme.modern:
        return Arena(left: left, top: top, width: width, height: height);
      case VisualTheme.classic:
        return ArenaV1(left: left, top: top, width: width, height: height);
    }
  }
}
