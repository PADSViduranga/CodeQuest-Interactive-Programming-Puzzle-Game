import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 24});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: size,
    width: size,
    child: const CircularProgressIndicator(
      strokeWidth: 2,
      color: AppColors.primaryLight,
    ),
  );
}
