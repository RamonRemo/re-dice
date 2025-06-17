import 'package:re_dice/app/controllers/arena_controller.dart';
import 'package:re_dice/app/controllers/dice_animation_controller.dart';
import 'package:re_dice/app/models/dice.dart';
import 'package:re_dice/app/models/dice_position.dart';
import 'package:re_dice/app/models/visual_theme.dart';
import 'package:re_dice/app/services/theme_service.dart';
import 'package:re_dice/app/widget/dice/dice_renderer_v1.dart';

class RendererFactory {
  static dynamic createDiceRenderer({
    required ArenaController arenaController,
    required List<Dice> diceList,
    required DiceAnimationController animationController,
  }) {
    switch (ThemeService.currentTheme) {
      case VisualTheme.modern:
        return DiceRenderer(
          arenaController: arenaController,
          diceList: diceList,
          animationController: animationController,
        );
      case VisualTheme.classic:
        return DiceRendererv1(
          arenaController: arenaController,
          diceList: diceList,
          animationController: animationController,
        );
    }
  }
}
