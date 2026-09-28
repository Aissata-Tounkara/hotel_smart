import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';

/// Ecran des parametres : theme clair/sombre/systeme et langue FR/EN.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();
    final themeMode = context.select<SettingsProvider, ThemeMode>(
      (provider) => provider.themeMode,
    );
    final languageCode = context.select<SettingsProvider, String>(
      (provider) => provider.locale.languageCode,
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PremiumAppBar(title: l10n.settings),
      body: FadeSlideIn(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                  icon: const Icon(Icons.light_mode_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                  icon: const Icon(Icons.settings_suggest_outlined),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (selection) =>
                  settingsProvider.changerTheme(selection.first),
            ),
            const OrnamentalDivider(),
            Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'fr', label: Text(l10n.languageFrench)),
                ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
              ],
              selected: {languageCode},
              onSelectionChanged: (selection) =>
                  settingsProvider.changerLangue(selection.first),
            ),
          ],
        ),
      ),
    );
  }
}
