import 'package:flutter/material.dart';

import '../core/theme/game_theme.dart';
import '../data/game_catalog.dart';
import '../models/game_definition.dart';
import '../integration/game_module_adapter.dart';
import '../services/player_progress.dart';

class GameHomeScreen extends StatefulWidget {
  const GameHomeScreen({super.key});

  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';
  String query = '';

  static const categories = ['All', 'Code', 'Algorithms', 'Web', 'Tools'];
  static const accents = [
    GameTheme.cyan,
    GameTheme.neon,
    GameTheme.gold,
    GameTheme.heart,
    Color(0xFF34D399),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<GameDefinition> get filteredGames => GameCatalog.games.where((game) {
    final matchesCategory =
        selectedCategory == 'All' || game.category == selectedCategory;
    final search = query.trim().toLowerCase();
    final matchesSearch =
        search.isEmpty ||
        game.title.toLowerCase().contains(search) ||
        game.description.toLowerCase().contains(search) ||
        game.category.toLowerCase().contains(search);
    return matchesCategory && matchesSearch;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF15132A),
              GameTheme.background,
              GameTheme.background,
            ],
            stops: [0, .35, 1],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                    sliver: SliverToBoxAdapter(child: _header()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                    sliver: SliverToBoxAdapter(child: _profilePanel()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverToBoxAdapter(child: _featuredChallenge()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                    sliver: SliverToBoxAdapter(child: _searchAndCategories()),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'CHOOSE YOUR NEXT RUN',
                              style: TextStyle(
                                color: GameTheme.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ),
                          Text(
                            '${filteredGames.length} GAMES',
                            style: const TextStyle(
                              color: GameTheme.cyan,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (filteredGames.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'No games match that search.',
                          style: TextStyle(color: GameTheme.muted),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
                      sliver: SliverLayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.crossAxisExtent;
                          final columns = width >= 980
                              ? 4
                              : width >= 650
                              ? 3
                              : width >= 390
                              ? 2
                              : 1;
                          return SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  _gameCard(filteredGames[index], index),
                              childCount: filteredGames.length,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                  mainAxisExtent: 194,
                                ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() => Row(
    children: [
      Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [GameTheme.purple, GameTheme.neon],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: GameTheme.neon.withValues(alpha: .28),
              blurRadius: 18,
            ),
          ],
        ),
        child: const Icon(Icons.code_rounded, color: Colors.white),
      ),
      const SizedBox(width: 12),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CODE QUEST',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'ARCADE  /  PLAYER HUB',
              style: TextStyle(
                color: GameTheme.muted,
                fontSize: 10,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
      ),
      IconButton(
        tooltip: 'Daily challenges',
        onPressed: () => _openGame(GameCatalog.games[1]),
        icon: const Icon(Icons.calendar_month_outlined),
        color: GameTheme.cyan,
      ),
      const CircleAvatar(
        backgroundColor: Color(0xFF34235D),
        child: Icon(Icons.person, color: Color(0xFFC9A7FF)),
      ),
    ],
  );

  Widget _profilePanel() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF29204A), Color(0xFF1C1B35)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: GameTheme.neon.withValues(alpha: .3)),
      boxShadow: [
        BoxShadow(color: GameTheme.neon.withValues(alpha: .1), blurRadius: 28),
      ],
    ),
    child: AnimatedBuilder(
      animation: PlayerProgress.instance,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final player = PlayerProgress.instance;
          final compact = constraints.maxWidth < 570;
          final identity = Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GameTheme.purple.withValues(alpha: .42),
                  border: Border.all(color: GameTheme.neon, width: 2),
                ),
                child: const Icon(
                  Icons.terminal,
                  size: 29,
                  color: GameTheme.cyan,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PLAYER 01',
                      style: TextStyle(
                        color: GameTheme.muted,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Code Explorer',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _stat(Icons.bolt, 'LVL ${player.level}', GameTheme.neon),
            ],
          );
          final progress = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'NEXT LEVEL',
                      style: TextStyle(
                        color: GameTheme.muted,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  if (!compact)
                    Text(
                      '${player.xp} / ${PlayerProgress.xpPerLevel} XP',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(width: 12),
                  _stat(
                    Icons.monetization_on,
                    '${player.coins}',
                    GameTheme.gold,
                  ),
                ],
              ),
              if (compact) ...[
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${player.xp} / ${PlayerProgress.xpPerLevel} XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: player.levelProgress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF131426),
                  valueColor: const AlwaysStoppedAnimation(GameTheme.neon),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'CHALLENGES CLEARED',
                      style: TextStyle(
                        color: GameTheme.muted,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Text(
                    '${player.completedGames.length} / ${GameCatalog.games.length}',
                    style: const TextStyle(
                      color: GameTheme.cyan,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          );
          return Column(
            children: [
              identity,
              SizedBox(height: compact ? 17 : 20),
              progress,
            ],
          );
        },
      ),
    ),
  );

  Widget _featuredChallenge() => InkWell(
    borderRadius: BorderRadius.circular(22),
    onTap: () => _openGame(GameCatalog.games[2]),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF40216E), Color(0xFF232043)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: GameTheme.gold.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: GameTheme.gold,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAILY CHALLENGE  •  +80 XP',
                  style: TextStyle(
                    color: GameTheme.gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .9,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Big O Sprint',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Can you spot the runtime?',
                  style: TextStyle(color: GameTheme.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_rounded, color: Colors.white),
        ],
      ),
    ),
  );

  Widget _searchAndCategories() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        controller: searchController,
        onChanged: (value) => setState(() => query = value),
        decoration: const InputDecoration(
          hintText: 'Search games, concepts...',
          prefixIcon: Icon(Icons.search, color: GameTheme.cyan),
        ),
      ),
      const SizedBox(height: 13),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final selected = selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category),
                selected: selected,
                onSelected: (_) => setState(() => selectedCategory = category),
                selectedColor: GameTheme.purple,
                backgroundColor: GameTheme.card,
                side: BorderSide(
                  color: selected ? GameTheme.neon : const Color(0xFF343651),
                ),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : GameTheme.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );

  Widget _gameCard(GameDefinition game, int index) {
    final accent = accents[index % accents.length];
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _openGame(game),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GameTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: .25)),
          boxShadow: [
            BoxShadow(color: accent.withValues(alpha: .06), blurRadius: 17),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(_gameIcon(game.id), color: accent),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _difficultyColor(game.difficulty)
                        .withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    game.difficulty.toUpperCase(),
                    style: TextStyle(
                      color: _difficultyColor(game.difficulty),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              game.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text(
              game.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: GameTheme.muted,
                fontSize: 11,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  game.category.toUpperCase(),
                  style: TextStyle(
                    color: accent,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white70,
                  size: 17,
                ),
                const Text(
                  ' PLAY',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String label, Color color) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 17, color: color),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    ],
  );

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Hard':
        return GameTheme.heart;
      case 'Medium':
        return GameTheme.gold;
      default:
        return const Color(0xFF34D399);
    }
  }

  IconData _gameIcon(String id) {
    switch (id) {
      case 'predict_output':
      case 'log_detective':
      case 'error_decoder':
        return Icons.terminal;
      case 'true_false_blitz':
        return Icons.bolt;
      case 'big_o_sprint':
      case 'sort_showdown':
        return Icons.speed;
      case 'git_quest':
      case 'tree_traversal':
        return Icons.account_tree;
      case 'status_code_match':
      case 'request_builder':
      case 'query_builder':
        return Icons.http;
      case 'code_review_duel':
      case 'bug_hunt':
        return Icons.gpp_maybe;
      case 'naming_judge':
        return Icons.badge_outlined;
      case 'operator_match':
      case 'logic_gates_lab':
        return Icons.memory;
      case 'word_scramble':
      case 'keyword_hangman':
        return Icons.extension;
      case 'binary_blitz':
        return Icons.numbers;
      case 'syntax_speedrun':
      case 'write_the_code':
        return Icons.code;
      case 'data_type_sorter':
      case 'code_match':
        return Icons.category;
      case 'block_builder':
      case 'flowchart_fixer':
      case 'code_maze':
        return Icons.account_tree_outlined;
      case 'recursion_tower':
      case 'stack_attack':
        return Icons.layers;
      case 'variable_tracer':
        return Icons.data_object;
      case 'regex_rush':
        return Icons.text_fields;
      default:
        return Icons.videogame_asset;
    }
  }

  void _openGame(GameDefinition game) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameModuleAdapter.buildGameScreen(game),
      ),
    );
  }
}
