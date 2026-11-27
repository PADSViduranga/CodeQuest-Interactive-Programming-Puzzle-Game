import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle get title => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );
  static TextStyle get heading => TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  static TextStyle get body =>
      TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.45);
  static TextStyle get label => TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
  static const code = TextStyle(
    color: AppColors.cyan,
    fontSize: 13,
    height: 1.55,
    fontFamily: 'monospace',
  );
}
