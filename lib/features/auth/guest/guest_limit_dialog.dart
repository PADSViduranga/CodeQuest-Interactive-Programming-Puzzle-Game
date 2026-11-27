import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

Future<void> showGuestLimitDialog(
  BuildContext context, {
  required VoidCallback onRegister,
  required VoidCallback onLogin,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.primary),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.yellowTint,
                  border: Border.all(color: AppColors.yellow, width: 1.5),
                ),
                child: const Icon(
                  Icons.timer_outlined,
                  size: 36,
                  color: AppColors.yellow,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Time's up, explorer!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Your 10 free guest minutes are used. Create an account to keep your XP and keep playing.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onRegister();
                },
                child: const Text('Create account'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onLogin();
                },
                child: const Text('Log in'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
