import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/game_factory.dart';
import '../../data/puzzle_repository.dart';
import '../../domain/puzzle.dart';
import '../../modules/registry.dart';

final gameFactoryProvider = Provider<GameFactory>((ref) => buildGameFactory());

final puzzleRepositoryProvider = Provider<PuzzleRepository>(
  (ref) => SamplePuzzleRepository(),
);

final stagePuzzlesProvider = FutureProvider.family<List<Puzzle>, String>((
  ref,
  stageId,
) {
  return ref.watch(puzzleRepositoryProvider).puzzlesForStage(stageId);
});
