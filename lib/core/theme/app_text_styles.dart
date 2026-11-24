import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );
  static const heading = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
  static const body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    height: 1.45,
  );
  static const label = TextStyle(
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
