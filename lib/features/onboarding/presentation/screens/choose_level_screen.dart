import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/learning_options.dart';

class ChooseLevelScreen extends ConsumerStatefulWidget {
  const ChooseLevelScreen({super.key});

  @override
  ConsumerState<ChooseLevelScreen> createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends ConsumerState<ChooseLevelScreen> {
  String? _selected;
  bool _saving = false;

  Future<void> _start() async {
    final user = ref.read(authStateProvider).value;
    if (user == null || _selected == null) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(profileRepositoryProvider)
          .updateSelection(user.uid, level: _selected);
      // The router sends the player home once both choices are saved.
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your level'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Step 2 of 2 · unlocks matching puzzles',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
              for (final l in levelOptions) ...[
                _LevelCard(
                  option: l,
                  selected: _selected == l.id,
                  onTap: () => setState(() => _selected = l.id),
                ),
                const SizedBox(height: 12),
              ],
              const Spacer(),
              FilledButton(
                onPressed: (_selected == null || _saving) ? null : _start,
                child: Text(_saving ? 'Saving...' : 'Start my quest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final LevelOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = option.color;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? c.withValues(alpha: 0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? c : AppColors.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected ? AppColors.glow(c) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: c.withValues(alpha: 0.6)),
              ),
              child: Icon(option.icon, color: c, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle, color: c),
          ],
        ),
      ),
    );
  }
}
