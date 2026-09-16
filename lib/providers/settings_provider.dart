import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

/// Etat global des parametres utilisateur : theme clair/sombre et langue
/// (FR/AR), persistes via SharedPreferences (point 35).
class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('fr');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get estArabe => _locale.languageCode == 'ar';

  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final themeSauvegarde = prefs.getString(AppConstants.prefThemeMode);
    final localeSauvegardee = prefs.getString(AppConstants.prefLocale);

    _themeMode = switch (themeSauvegarde) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _locale = Locale(localeSauvegardee ?? 'fr');
    notifyListeners();
  }

  Future<void> changerTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefThemeMode, mode.name);
  }

  Future<void> changerLangue(String codeLangue) async {
    _locale = Locale(codeLangue);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefLocale, codeLangue);
  }
}
