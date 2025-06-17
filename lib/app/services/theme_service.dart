import 'package:re_dice/app/models/visual_theme.dart';
import 'package:re_dice/app/services/preferences_service.dart';

class ThemeService {
  static const _themeKey = 'visual_theme';
  static VisualTheme _currentTheme = VisualTheme.modern;

  static VisualTheme get currentTheme => _currentTheme;

  static Future<void> init() async {
    final savedTheme = PreferencesService.getString(_themeKey);
    if (savedTheme != null) {
      _currentTheme = VisualTheme.values.firstWhere(
        (theme) => theme.name == savedTheme,
        orElse: () => VisualTheme.modern,
      );
    }
  }

  static Future<void> toggleTheme() async {
    _currentTheme = _currentTheme.next;
    await PreferencesService.saveString(_themeKey, _currentTheme.name);
  }
}
