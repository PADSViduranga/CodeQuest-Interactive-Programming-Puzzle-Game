# Member 4 - Code Quest Arcade

A standalone, local-data Flutter mini-game module with a neon arcade home screen,
30 programming challenges and reusable gameplay engines. No Firebase, backend,
or additional package is required.

## Run on Windows with Microsoft Edge

From the project directory:

```powershell
flutter pub get
flutter run -d edge
```

Run the widget and catalog tests with:

```powershell
flutter test
```

## What's included

- Responsive home hub with search, category filters, player/XP/coin panels and
  difficulty-tagged game cards.
- Thirty local challenges covering code reading, algorithms, Git, web concepts,
  debugging, data types, and more.
- Distinct interactions: multiple choice, typing/code entry, drag-to-buckets,
  hangman, tap-a-code-line, reorderable sequences, live logic gates, adjacent
  bar sorting, and a push/pop stack.
- Shared session UI with hearts, timer, progress, combo, four one-use power-ups,
  explanations, replay, and next challenge.
- Local in-memory XP, level, coin, and completed-game progress updates on wins.

## Beginner-friendly file map

- `lib/main.dart` and `lib/core/theme/game_theme.dart`: app entry point and colors.
- `lib/screens/home_screen.dart`: responsive home, search, categories, game cards.
- `lib/screens/game_screen.dart`: timer, lives, power-ups and game session.
- `lib/services/player_progress.dart`: local sample profile progression.
- `lib/data/game_catalog.dart`: all sample game content, separate from widgets.
- `lib/models/game_definition.dart`: local challenge model and interaction modes.
- `lib/engines/`: reusable interaction widgets; new game formats are in
  `special_game_engines.dart`.
- `lib/integration/game_module_adapter.dart`: local integration seam.
- `test/`: engine widget tests and a 30-game catalog/home test.

## Member 3 integration boundary

The shared `GameModule` interface was not included in this standalone project.
`GameModuleAdapter.buildGameScreen` is intentionally a small local adapter, not
a guessed definition of the team's contract. When Member 3 provides the real
interface, map that agreed interface in the adapter and connect the completion
result there. Keep `GameCatalog` as local sample content until the team agrees
on its shared data source.

## Suggested development stages

1. Run the existing and catalog tests, then launch the home hub in Edge.
2. Play one challenge per interaction style and adjust local prompts in
   `lib/data/game_catalog.dart`.
3. Confirm Member 3's module/session interface, then implement the mapping in
   `lib/integration/game_module_adapter.dart`.
