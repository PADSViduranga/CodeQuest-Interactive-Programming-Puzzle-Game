import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({
    super.key,
    required this.language,
    required this.level,
    required this.onOpenLesson,
  });

  final String language;
  final String level;
  final VoidCallback onOpenLesson;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          child: Row(
            children: [
              const Expanded(
                child: Text('Your learning world', style: AppTextStyles.title),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellowTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: AppColors.yellow,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '7',
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            const MitoBubble(
              message: 'Welcome back, Questor! Ready to continue your coding adventure?',
              mood: MitoMood.happy,
            ),
            const SizedBox(height: 24),
            const SectionTitle(
              'Python Valley',
              action: Text(
                '1 / 8',
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 14),
            _StagePath(onOpenLesson: onOpenLesson),
          ]),
        ),
      ),
    ],
  );
}

class _StagePath extends StatelessWidget {
  const _StagePath({required this.onOpenLesson});

  final VoidCallback onOpenLesson;

  @override
  Widget build(BuildContext context) {
    const stages = [
      ('01', 'Variables & values', 'Completed', AppColors.green, true),
      (
        '02',
        'The branching forest',
        'Current quest',
        AppColors.primaryLight,
        true,
      ),
      ('03', 'Loops lagoon', 'Locked', AppColors.textMuted, false),
      ('04', 'Function fortress', 'Locked', AppColors.textMuted, false),
      ('05', 'The Python boss', 'Boss stage', AppColors.yellow, false),
    ];

    return Column(
      children: List.generate(stages.length, (index) {
        final stage = stages[index];
        return Column(
          children: [
            InkWell(
              onTap: stage.$5
                  ? () => _showStageDetails(context, stage.$2, stage.$3)
                  : null,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: stage.$3 == 'Current quest'
                      ? AppColors.purpleTint
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: index == 1 ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: stage.$3 == 'Locked'
                            ? AppColors.surfaceRaised
                            : stage.$4.withValues(alpha: .18),
                        border: Border.all(color: stage.$4, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          stage.$1,
                          style: TextStyle(
                            color: stage.$4,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stage.$2,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stage.$3,
                            style: TextStyle(
                              color: stage.$4,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      stage.$3 == 'Locked'
                          ? Icons.lock_outline
                          : (stage.$3 == 'Completed'
                                ? Icons.check_circle
                                : Icons.arrow_forward_ios),
                      size: 18,
                      color: stage.$4,
                    ),
                  ],
                ),
              ),
            ),
            if (index != stages.length - 1)
              Container(
                height: 24,
                width: 2,
                color: index < 2 ? AppColors.primary : AppColors.border,
              ),
          ],
        );
      }),
    );
  }

  void _showStageDetails(BuildContext context, String title, String status) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(title, style: AppTextStyles.title),
              const SizedBox(height: 8),
              Text(
                '$status • 3 lessons • 1 practice challenge',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 16),
              const MitoBubble(
                message: 'This stage has a lesson and a puzzle. Take your time and watch for clues!',
                mood: MitoMood.thinking,
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Start lesson',
                icon: Icons.play_arrow_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                  onOpenLesson();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
