/// Constantes globales de l'application (noms de tables, cles de
/// preferences, valeurs par defaut). Centraliser ces valeurs evite les
/// erreurs de frappe repetees dans les repositories et services.
class AppConstants {
  AppConstants._();

  // Noms des tables SQLite
  static const String tableUsers = 'users';
  static const String tableRooms = 'rooms';
  static const String tableClients = 'clients';
  static const String tableReservations = 'reservations';
  static const String tablePayments = 'payments';
  static const String tableNotifications = 'notifications';

  // Cles SharedPreferences
  static const String prefUserId = 'session_user_id';
  static const String prefThemeMode = 'pref_theme_mode';
  static const String prefLocale = 'pref_locale';

  // Compte administrateur par defaut (cree au premier lancement)
  static const String defaultAdminEmail = 'admin@hotelsmart.dz';
  static const String defaultAdminPassword = 'Admin@123';
  static const String defaultAdminName = 'Administrateur';

  // API externe (nationalites)
  //
  // Historique : le cahier des charges citait restcountries.com/v3.1, mis
  // hors service (redirige vers une v5 qui exige une cle API, inadaptee a
  // une app mobile ou toute cle embarquee est visible par decompilation).
  // Remplacee par countries.dev, gratuite et sans authentification.
  static const String countriesApiUrl = 'https://countries.dev/countries?fields=name';
}
