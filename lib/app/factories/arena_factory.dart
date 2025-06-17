import 'package:flutter/material.dart';

import 'package:re_dice/app/models/visual_theme.dart';
import 'package:re_dice/app/services/theme_service.dart';
import 'package:re_dice/app/widget/arena/arena.dart';
import 'package:re_dice/app/widget/arena/arena_v1.dart';

class ArenaFactory {
  static Widget createArena({
    required double arenaLeft,
    required double arenaTop,
    required double arenaWidth,
    required double arenaHeight,
  }) {
    switch (ThemeService.currentTheme) {
      case VisualTheme.modern:
        return Arena(
          arenaLeft: arenaLeft,
          arenaTop: arenaTop,
          arenaWidth: arenaWidth,
          arenaHeight: arenaHeight,
        );
      case VisualTheme.classic:
        return ArenaV1(
          arenaLeft: arenaLeft,
          arenaTop: arenaTop,
          arenaWidth: arenaWidth,
          arenaHeight: arenaHeight,
        );
    }
  }
}
