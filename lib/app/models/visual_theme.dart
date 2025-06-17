enum VisualTheme { modern, classic }

extension VisualThemeExtension on VisualTheme {
  String get displayName {
    switch (this) {
      case VisualTheme.modern:
        return 'v1';
      case VisualTheme.classic:
        return 'v0';
    }
  }

  VisualTheme get next {
    switch (this) {
      case VisualTheme.modern:
        return VisualTheme.classic;
      case VisualTheme.classic:
        return VisualTheme.modern;
    }
  }
}
