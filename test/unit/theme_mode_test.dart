import 'package:flutter_test/flutter_test.dart';
import 'package:codequest/core/theme/app_colors.dart';
import 'package:codequest/core/theme/app_theme.dart';

void main() {
  test('light and dark themes use different backgrounds', () {
    final darkBackground = AppTheme.dark.scaffoldBackgroundColor;
    expect(AppColors.isDark, isTrue);

    final lightBackground = AppTheme.light.scaffoldBackgroundColor;
    expect(AppColors.isDark, isFalse);

    expect(lightBackground, isNot(darkBackground));
    AppTheme.dark;
  });
}
