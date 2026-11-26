import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/profile_edit_service.dart';
import '../widgets/avatar_circle.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _name = TextEditingController();
  String _avatar = 'mito_1';
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final p = await ref.read(profileEditServiceProvider).load();
      if (!mounted) return;
      setState(() {
        _name.text = p.displayName;
        _avatar = p.avatarId;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load your profile.';
      });
    }
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.length < 2 || name.length > 20) {
      setState(() => _error = 'Pick a name between 2 and 20 characters.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(profileEditServiceProvider)
          .save(displayName: name, avatarId: _avatar);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not save. Check your connection.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Center(child: AvatarCircle(avatarId: _avatar, size: 104)),
                const SizedBox(height: 24),
                const Text(
                  'Choose your Mito',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    for (final a in avatarOptions)
                      GestureDetector(
                        onTap: _saving
                            ? null
                            : () => setState(() => _avatar = a.id),
                        child: Opacity(
                          opacity: _avatar == a.id ? 1 : 0.55,
                          child: AvatarCircle(
                            avatarId: a.id,
                            size: 60,
                            selected: _avatar == a.id,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _name,
                  enabled: !_saving,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Display name',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _error!,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(_saving ? 'Saving...' : 'Save'),
                ),
              ],
            ),
    );
  }
}
