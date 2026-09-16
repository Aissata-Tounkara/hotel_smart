import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../utils/app_strings.dart';

/// Ecran des parametres : theme clair/sombre/systeme et langue FR/AR
/// (point 35).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final arabe = settingsProvider.estArabe;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get('parametres', arabe: arabe))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(AppStrings.get('theme', arabe: arabe), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(value: ThemeMode.light, label: Text(AppStrings.get('theme_clair', arabe: arabe)), icon: const Icon(Icons.light_mode_outlined)),
              ButtonSegment(value: ThemeMode.dark, label: Text(AppStrings.get('theme_sombre', arabe: arabe)), icon: const Icon(Icons.dark_mode_outlined)),
              ButtonSegment(value: ThemeMode.system, label: Text(AppStrings.get('theme_systeme', arabe: arabe)), icon: const Icon(Icons.settings_suggest_outlined)),
            ],
            selected: {settingsProvider.themeMode},
            onSelectionChanged: (selection) => settingsProvider.changerTheme(selection.first),
          ),
          const SizedBox(height: 32),
          Text(AppStrings.get('langue', arabe: arabe), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'fr', label: Text('Francais')),
              ButtonSegment(value: 'ar', label: Text('العربية')),
            ],
            selected: {settingsProvider.locale.languageCode},
            onSelectionChanged: (selection) => settingsProvider.changerLangue(selection.first),
          ),
        ],
      ),
    );
  }
}
