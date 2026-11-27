import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../world_map/presentation/providers/world_provider.dart';
import '../../domain/lesson.dart';

class LessonScreen extends ConsumerWidget {
  const LessonScreen({super.key, required this.stageId});

  final String stageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonAsync = ref.watch(lessonProvider(stageId));
    final lesson = lessonAsync.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: lessonAsync.isLoading
          ? const Center(child: CircularProgressIndicator())
          : lesson == null
          ? const Center(child: Text('This lesson is not ready yet.'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  lesson.explanation,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                _CodeBox(lines: lesson.example),
                const SizedBox(height: 12),
                _OutputBox(lines: lesson.output),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.yellowTint,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.yellow.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.yellow,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          lesson.tip,
                          style: TextStyle(color: AppColors.yellowInk),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: const Text('Got it'),
                ),
              ],
            ),
    );
  }
}

class _CodeBox extends StatelessWidget {
  const _CodeBox({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
    decoration: BoxDecoration(
      color: AppColors.cyanTint,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.7,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  lines[i],
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

class _OutputBox extends StatelessWidget {
  const _OutputBox({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.greenTint,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.green.withValues(alpha: 0.5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OUTPUT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.greenInk,
          ),
        ),
        const SizedBox(height: 6),
        for (final l in lines)
          Text(
            l,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              height: 1.6,
            ),
          ),
      ],
    ),
  );
}
