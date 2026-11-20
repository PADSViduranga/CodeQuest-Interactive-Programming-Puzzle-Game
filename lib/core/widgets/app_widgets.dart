import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.secondary = false,
    this.loading = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool secondary;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );
    return secondary
        ? OutlinedButton(onPressed: loading ? null : onPressed, child: child)
        : ElevatedButton(onPressed: loading ? null : onPressed, child: child);
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action});
  final String title;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: AppTextStyles.heading),
      ?action,
    ],
  );
}

class CodeCard extends StatelessWidget {
  const CodeCard({super.key, required this.code, this.onCopy});
  final String code;
  final VoidCallback? onCopy;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.cyanTint,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 28),
          child: SelectableText(code, style: AppTextStyles.code),
        ),
        if (onCopy != null)
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: onCopy,
              icon: const Icon(
                Icons.copy_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
              tooltip: 'Copy code',
            ),
          ),
      ],
    ),
  );
}

class MitoBubble extends StatelessWidget {
  const MitoBubble({
    super.key,
    required this.message,
    this.mood = MitoMood.happy,
  });
  final String message;
  final MitoMood mood;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: AppColors.purpleTint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary),
        ),
        child: Icon(mood.icon, color: mood.color, size: 26),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(message, style: AppTextStyles.body),
        ),
      ),
    ],
  );
}

enum MitoMood {
  happy(Icons.auto_awesome, AppColors.yellow),
  celebrate(Icons.celebration, AppColors.green),
  thinking(Icons.psychology, AppColors.cyan),
  worried(Icons.sentiment_dissatisfied, AppColors.pinkRed);

  const MitoMood(this.icon, this.color);
  final IconData icon;
  final Color color;
}

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primary,
  });
  final double value;
  final Color color;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(5),
    child: LinearProgressIndicator(
      value: value.clamp(0, 1).toDouble(),
      minHeight: 7,
      backgroundColor: AppColors.surfaceRaised,
      valueColor: AlwaysStoppedAnimation(color),
    ),
  );
}
