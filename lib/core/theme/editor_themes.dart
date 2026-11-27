import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

abstract final class EditorThemes {
  static TextStyle get dark => TextStyle(
    color: AppColors.textPrimary,
    fontFamily: 'monospace',
    fontSize: 13,
    height: 1.55,
  );

  static Color get keywords => AppColors.primaryLight;
  static const strings = AppColors.green;
  static const numbers = AppColors.yellow;
  static Color get comments => AppColors.textMuted;
}
