import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../lessons/domain/lesson.dart';
import '../../data/world_repository.dart';
import '../../domain/stage.dart';

final worldRepositoryProvider = Provider<WorldRepository>(
  (ref) => WorldRepository(FirebaseFirestore.instance),
);

/// Stages from Firestore. If there are none yet, or the read fails,
/// the built-in sample stages are used so the map is never empty.
final stagesProvider = FutureProvider<List<Stage>>((ref) async {
  try {
    final stages = await ref.watch(worldRepositoryProvider).loadStages();
    return stages.isEmpty ? sampleStages : stages;
  } catch (_) {
    return sampleStages;
  }
});

/// One lesson, with the same fallback to the built-in samples.
final lessonProvider = FutureProvider.family<Lesson?, String>((
  ref,
  stageId,
) async {
  try {
    final lesson = await ref.watch(worldRepositoryProvider).loadLesson(stageId);
    return lesson ?? sampleLessons[stageId];
  } catch (_) {
    return sampleLessons[stageId];
  }
});
