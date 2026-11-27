import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, this.message});
  final String title;
  final String? message;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome, color: AppColors.primaryLight, size: 42),
        const SizedBox(height: 12),
        Text(title, style: AppTextStyles.heading),
        if (message != null) ...[
          const SizedBox(height: 6),
          Text(
            message!,
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    ),
  );
}
