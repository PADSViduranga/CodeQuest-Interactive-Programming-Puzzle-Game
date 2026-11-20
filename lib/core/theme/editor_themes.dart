import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class EditorThemes {
  static const dark = TextStyle(
    color: AppColors.textPrimary,
    fontFamily: 'monospace',
    fontSize: 13,
    height: 1.55,
  );

  static const keywords = AppColors.primaryLight;
  static const strings = AppColors.green;
  static const numbers = AppColors.yellow;
  static const comments = AppColors.textMuted;
}
