import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.language,
    required this.level,
    required this.onProfileChanged,
  });

  final String language;
  final String level;
  final VoidCallback onProfileChanged;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool audioEnabled = true;
  bool hapticsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      audioEnabled = prefs.getBool('audio_enabled') ?? true;
      hapticsEnabled = prefs.getBool('haptics_enabled') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('Your profile', style: AppTextStyles.title),
      const SizedBox(height: 20),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.purpleTint,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primaryLight,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Questor', style: AppTextStyles.heading),
                  Text(
                    '${widget.language} • ${widget.level}',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      const SectionTitle('Settings'),
      const SizedBox(height: 10),
      Card(
        child: Column(
          children: [
            SwitchListTile(
              secondary: const Icon(
                Icons.volume_up_outlined,
                color: AppColors.cyan,
              ),
              title: const Text('Sound effects'),
              value: audioEnabled,
              onChanged: (value) {
                setState(() => audioEnabled = value);
                _saveSetting('audio_enabled', value);
              },
            ),
            SwitchListTile(
              secondary: const Icon(Icons.vibration, color: AppColors.green),
              title: const Text('Haptics'),
              value: hapticsEnabled,
              onChanged: (value) {
                setState(() => hapticsEnabled = value);
                _saveSetting('haptics_enabled', value);
              },
            ),
          ],
        ),
      ),
    ],
  );
}
