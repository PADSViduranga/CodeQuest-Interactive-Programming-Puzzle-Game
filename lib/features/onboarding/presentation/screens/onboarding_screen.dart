import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final Future<void> Function(String language, String level) onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  int page = 0;
  String language = 'Python';
  String level = 'Beginner';
  bool saving = false;

  final slides = const [
    (
      'Learn by playing',
      'Master programming through bite-sized quests, puzzles, and real code.',
      Icons.sports_esports,
    ),
    (
      'Build your streak',
      'Complete daily challenges, earn XP, and unlock new worlds.',
      Icons.local_fire_department,
    ),
    (
      'Your guide, Mito',
      'Get helpful hints whenever you are stuck. Your adventure starts now.',
      Icons.auto_awesome,
    ),
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSetup = page == slides.length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CODEQUEST',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  if (!isSetup)
                    TextButton(
                      onPressed: () => setState(() => page = slides.length),
                      child: const Text('Skip'),
                    ),
                ],
              ),
              Expanded(
                child: isSetup
                    ? _ToolkitAndLevelPage(
                        language: language,
                        level: level,
                        onLanguage: (value) => setState(() => language = value),
                        onLevel: (value) => setState(() => level = value),
                      )
                    : PageView.builder(
                        controller: pageController,
                        onPageChanged: (value) => setState(() => page = value),
                        itemCount: slides.length,
                        itemBuilder: (_, index) =>
                            _TutorialSlide(slide: slides[index]),
                      ),
              ),
              if (!isSetup) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: index == page ? 22 : 6,
                      decoration: BoxDecoration(
                        color: index == page
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: page == slides.length - 1
                      ? 'Choose your toolkit'
                      : 'Next',
                  onPressed: () {
                    if (page == slides.length - 1) {
                      setState(() => page = slides.length);
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  icon: Icons.arrow_forward,
                ),
              ] else
                AppButton(
                  label: 'Start my journey',
                  loading: saving,
                  onPressed: () async {
                    setState(() => saving = true);
                    await widget.onComplete(language, level);
                  },
                  icon: Icons.rocket_launch,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialSlide extends StatelessWidget {
  const _TutorialSlide({required this.slide});

  final (String, String, IconData) slide;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.purpleTint,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .3),
              blurRadius: 40,
            ),
          ],
        ),
        child: Icon(slide.$3, size: 72, color: AppColors.primaryLight),
      ),
      const SizedBox(height: 42),
      Text(slide.$1, style: AppTextStyles.title, textAlign: TextAlign.center),
      const SizedBox(height: 12),
      Text(slide.$2, style: AppTextStyles.body, textAlign: TextAlign.center),
    ],
  );
}

class _ToolkitAndLevelPage extends StatelessWidget {
  const _ToolkitAndLevelPage({
    required this.language,
    required this.level,
    required this.onLanguage,
    required this.onLevel,
  });

  final String language;
  final String level;
  final ValueChanged<String> onLanguage;
  final ValueChanged<String> onLevel;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.only(top: 18),
    children: [
      const Text('Choose your toolkit', style: AppTextStyles.title),
      const SizedBox(height: 8),
      const Text(
        'Pick a language to shape your first quests.',
        style: AppTextStyles.body,
      ),
      const SizedBox(height: 22),
      const Text('LANGUAGES', style: AppTextStyles.label),
      const SizedBox(height: 10),
      _ChoiceCard(
        label: 'Python',
        caption: 'Friendly and powerful',
        icon: Icons.data_object,
        selected: language == 'Python',
        onTap: () => onLanguage('Python'),
      ),
      const SizedBox(height: 10),
      _ChoiceCard(
        label: 'JavaScript',
        caption: 'Coming soon',
        icon: Icons.javascript,
        selected: false,
        onTap: () {},
        disabled: true,
      ),
      const SizedBox(height: 10),
      const Text('FRAMEWORKS', style: AppTextStyles.label),
      const SizedBox(height: 10),
      _ChoiceCard(
        label: 'Dart & Flutter',
        caption: 'Coming soon',
        icon: Icons.flutter_dash,
        selected: false,
        onTap: () {},
        disabled: true,
      ),
      const SizedBox(height: 24),
      const Text('YOUR LEVEL', style: AppTextStyles.label),
      const SizedBox(height: 10),
      ...['Beginner', 'Intermediate', 'Advanced'].map(
        (item) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _ChoiceCard(
            label: item,
            caption: {
              'Beginner': 'I am just starting out',
              'Intermediate': 'I know the basics',
              'Advanced': 'Challenge me',
            }[item]!,
            icon: {
              'Beginner': Icons.emoji_events_outlined,
              'Intermediate': Icons.bolt,
              'Advanced': Icons.diamond_outlined,
            }[item]!,
            selected: level == item,
            onTap: () => onLevel(item),
          ),
        ),
      ),
    ],
  );
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.label,
    required this.caption,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.disabled = false,
  });

  final String label;
  final String caption;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: disabled ? null : onTap,
    borderRadius: BorderRadius.circular(16),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selected ? AppColors.purpleTint : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: disabled
                ? AppColors.textMuted
                : (selected ? AppColors.primaryLight : AppColors.textSecondary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(caption, style: AppTextStyles.label),
              ],
            ),
          ),
          if (disabled)
            const Chip(
              label: Text(
                'COMING SOON',
                style: TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
            )
          else if (selected)
            const Icon(Icons.check_circle, color: AppColors.primaryLight),
        ],
      ),
    ),
  );
}
