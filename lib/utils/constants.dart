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
  static const String restCountriesUrl = 'https://restcountries.com/v3.1/all?fields=name';
}
