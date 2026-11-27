import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/audio_service.dart';
import '../../../../core/services/haptics_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/widgets/confetti_overlay.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Practice arena')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Choose a challenge', style: AppTextStyles.title),
        const SizedBox(height: 8),
        Text('Put your new skills to the test.', style: AppTextStyles.body),
        const SizedBox(height: 22),
        _GameCard(
          title: 'Code Maze',
          description: 'Guide your player through the algorithm.',
          icon: Icons.grid_4x4,
          color: AppColors.cyan,
          onTap: () => _open(context, const CodeMazeGame()),
        ),
        _GameCard(
          title: 'Logic Gates Lab',
          description: 'Connect inputs to unlock the output.',
          icon: Icons.account_tree_outlined,
          color: AppColors.green,
          onTap: () => _open(context, const LogicGatesGame()),
        ),
        _GameCard(
          title: 'Sort Showdown',
          description: 'Sort the values before time runs out.',
          icon: Icons.swap_vert,
          color: AppColors.yellow,
          onTap: () => _open(context, const SortShowdownGame()),
        ),
        _GameCard(
          title: 'Recursion Tower',
          description: 'Climb one call stack at a time.',
          icon: Icons.stairs,
          color: AppColors.pinkRed,
          onTap: () => _open(context, const RecursionTowerGame()),
        ),
      ],
    ),
  );

  static void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: AppTextStyles.label),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    ),
  );
}

class CodeMazeGame extends StatefulWidget {
  const CodeMazeGame({super.key});

  @override
  State<CodeMazeGame> createState() => _CodeMazeGameState();
}

class _CodeMazeGameState extends State<CodeMazeGame> {
  int player = 0;

  static const blocked = {7, 8, 12, 17, 18};
  final audio = AudioService();
  final haptics = HapticsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    audio.enabled = prefs.getBool('audio_enabled') ?? true;
    haptics.enabled = prefs.getBool('haptics_enabled') ?? true;
  }

  void _move(int next) {
    final currentRow = player ~/ 5;
    final nextRow = next ~/ 5;
    final crossesRow =
        (next == player - 1 || next == player + 1) && currentRow != nextRow;
    if (next < 0 || next >= 25 || crossesRow || blocked.contains(next)) {
      haptics.error();
      audio.error();
      return;
    }
    setState(() => player = next);
    haptics.tap();
    if (player == 24) {
      haptics.success();
      audio.success();
    }
  }

  @override
  Widget build(BuildContext context) => ConfettiOverlay(
    visible: player == 24,
    child: _GameScaffold(
      title: 'Code Maze',
      instruction: 'Reach the cyan goal without hitting a wall.',
      color: AppColors.cyan,
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(25, (index) {
              final isBlocked = blocked.contains(index);
              final isGoal = index == 24;
              final isPlayer = index == player;
              return Container(
                decoration: BoxDecoration(
                  color: isPlayer
                      ? AppColors.cyanTint
                      : (isGoal
                            ? AppColors.greenTint
                            : (isBlocked
                                  ? AppColors.surfaceRaised
                                  : AppColors.surface)),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isPlayer
                        ? AppColors.cyan
                        : (isGoal
                              ? AppColors.green
                              : (isBlocked
                                    ? AppColors.border
                                    : AppColors.border)),
                  ),
                ),
                child: Icon(
                  isBlocked
                      ? Icons.block
                      : (isPlayer
                            ? Icons.smart_toy
                            : (isGoal ? Icons.flag : null)),
                  color: isPlayer
                      ? AppColors.cyan
                      : (isGoal ? AppColors.green : AppColors.textMuted),
                  size: 18,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: [
              IconButton.filled(
                onPressed: () => _move(player - 5),
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton.filled(
                onPressed: () => _move(player - 1),
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton.filled(
                onPressed: () => _move(player + 1),
                icon: const Icon(Icons.arrow_forward),
              ),
              IconButton.filled(
                onPressed: () => _move(player + 5),
                icon: const Icon(Icons.arrow_downward),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            player == 24 ? 'Goal reached!' : 'Position ${player + 1}',
            style: TextStyle(
              color: player == 24 ? AppColors.green : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class LogicGatesGame extends StatefulWidget {
  const LogicGatesGame({super.key});

  @override
  State<LogicGatesGame> createState() => _LogicGatesGameState();
}

class _LogicGatesGameState extends State<LogicGatesGame> {
  bool a = true;
  bool b = false;
  final audio = AudioService();
  final haptics = HapticsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    audio.enabled = prefs.getBool('audio_enabled') ?? true;
    haptics.enabled = prefs.getBool('haptics_enabled') ?? true;
  }

  void _setInput(bool? value, bool isA) {
    setState(() {
      if (isA) {
        a = value ?? false;
      } else {
        b = value ?? false;
      }
    });
    haptics.tap();
    if (a && b) {
      haptics.success();
      audio.success();
    }
  }

  @override
  Widget build(BuildContext context) => ConfettiOverlay(
    visible: a && b,
    child: _GameScaffold(
      title: 'Logic Gates Lab',
      instruction: 'Toggle both inputs to produce TRUE.',
      color: AppColors.green,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SwitchNode(
                label: 'A',
                value: a,
                onChanged: (value) => _setInput(value, true),
              ),
              _SwitchNode(
                label: 'B',
                value: b,
                onChanged: (value) => _setInput(value, false),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Icon(Icons.arrow_downward, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: a && b ? AppColors.greenTint : AppColors.redTint,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: a && b ? AppColors.green : AppColors.pinkRed,
              ),
            ),
            child: Column(
              children: [
                Text('AND GATE', style: AppTextStyles.label),
                const SizedBox(height: 8),
                Text(
                  a && b ? 'TRUE' : 'FALSE',
                  style: TextStyle(
                    color: a && b ? AppColors.green : AppColors.pinkRed,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _SwitchNode extends StatelessWidget {
  const _SwitchNode({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(label, style: AppTextStyles.heading),
      Switch(value: value, onChanged: onChanged),
    ],
  );
}

class SortShowdownGame extends StatefulWidget {
  const SortShowdownGame({super.key});

  @override
  State<SortShowdownGame> createState() => _SortShowdownGameState();
}

class _SortShowdownGameState extends State<SortShowdownGame> {
  List<int> values = [42, 7, 19, 3];
  int? selected;
  final audio = AudioService();
  final haptics = HapticsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    audio.enabled = prefs.getBool('audio_enabled') ?? true;
    haptics.enabled = prefs.getBool('haptics_enabled') ?? true;
  }

  void _select(int index) {
    haptics.tap();
    setState(() {
      if (selected == null) {
        selected = index;
      } else {
        if (selected != index) {
          final first = values[selected!];
          values[selected!] = values[index];
          values[index] = first;
        }
        selected = null;
      }
    });
    final sorted = List<int>.from(values)..sort();
    if (List<int>.from(values).join() == sorted.join()) {
      haptics.success();
      audio.success();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List<int>.from(values)..sort();
    final complete = List<int>.from(values).join() == sorted.join();
    final items = values.asMap().entries.map<Widget>((entry) {
      final index = entry.key;
      final value = entry.value;
      return GestureDetector(
        onTap: () => _select(index),
        child: SizedBox(
          width: 70,
          height: 70,
          child: Card(
            color: selected == index
                ? AppColors.primaryDark
                : AppColors.yellowTint,
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  color: AppColors.yellowInk,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();

    return ConfettiOverlay(
      visible: complete,
      child: _GameScaffold(
        title: 'Sort Showdown',
        instruction: 'Tap two values to swap them into ascending order.',
        color: AppColors.yellow,
        child: Column(
          children: [
            Wrap(spacing: 10, runSpacing: 10, children: items),
            const SizedBox(height: 16),
            Text(
              complete ? 'Sorted correctly!' : 'Ascending order',
              style: TextStyle(
                color: complete ? AppColors.green : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecursionTowerGame extends StatefulWidget {
  const RecursionTowerGame({super.key});

  @override
  State<RecursionTowerGame> createState() => _RecursionTowerGameState();
}

class _RecursionTowerGameState extends State<RecursionTowerGame> {
  int step = 0;
  final audio = AudioService();
  final haptics = HapticsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    audio.enabled = prefs.getBool('audio_enabled') ?? true;
    haptics.enabled = prefs.getBool('haptics_enabled') ?? true;
  }

  void _advance() {
    if (step < 3) {
      setState(() => step += 1);
      haptics.tap();
    }
    if (step == 3) {
      haptics.success();
      audio.success();
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = List<Widget>.generate(
      3,
      (index) => AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: index < step ? 1 : .28,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.redTint,
            child: Text('${3 - index}'),
          ),
          title: Text('countdown(${3 - index})'),
          trailing: Icon(
            index < step ? Icons.check : Icons.schedule,
            color: index < step ? AppColors.green : AppColors.textMuted,
          ),
        ),
      ),
    );

    return ConfettiOverlay(
      visible: step == 3,
      child: _GameScaffold(
        title: 'Recursion Tower',
        instruction: 'Advance through each function call until the base case.',
        color: AppColors.pinkRed,
        child: Column(
          children: [
            const CodeCard(
              code:
                  'def countdown(n):\n'
                  '  if n == 0:\n'
                  '    return\n'
                  '  countdown(n - 1)',
            ),
            const SizedBox(height: 20),
            ...steps,
            const SizedBox(height: 12),
            AppButton(
              label: step == 3 ? 'Base case reached' : 'Next call',
              onPressed: step == 3 ? null : _advance,
              icon: step == 3 ? Icons.celebration : Icons.arrow_downward,
            ),
          ],
        ),
      ),
    );
  }
}

class _GameScaffold extends StatelessWidget {
  const _GameScaffold({
    required this.title,
    required this.instruction,
    required this.color,
    required this.child,
  });

  final String title;
  final String instruction;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(instruction, style: AppTextStyles.body),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: .55)),
          ),
          child: child,
        ),
      ],
    ),
  );
}
