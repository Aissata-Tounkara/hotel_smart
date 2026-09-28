// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get emailRequired => 'L\'email est obligatoire';

  @override
  String get emailInvalid => 'Format email invalide';

  @override
  String get passwordRequired => 'Le mot de passe est obligatoire';

  @override
  String get authNoAccount => 'Aucun compte ne correspond à cet email';

  @override
  String get authWrongPassword => 'Mot de passe incorrect';

  @override
  String get authUnexpected => 'Erreur inattendue : impossible de se connecter';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get logout => 'Déconnexion';

  @override
  String get notifications => 'Notifications';

  @override
  String get markNotificationRead => 'Marquer la notification comme lue';

  @override
  String get noUnreadNotifications => 'Aucune notification non lue';

  @override
  String get noUserSignedIn => 'Aucun utilisateur connecté';

  @override
  String welcomeUser(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get quickAccess => 'Accès rapide';

  @override
  String get monthlyRevenue => 'Chiffre d’affaires du mois';

  @override
  String get occupancyRate => 'Taux d’occupation';

  @override
  String get availableRooms => 'Disponibles';

  @override
  String get occupiedRooms => 'Occupées';

  @override
  String get todayReservations => 'Réservations du jour';

  @override
  String get rooms => 'Chambres';

  @override
  String get reservations => 'Réservations';

  @override
  String get clients => 'Clients';

  @override
  String get payments => 'Paiements';

  @override
  String get users => 'Utilisateurs';

  @override
  String get statistics => 'Statistiques';

  @override
  String get myReservations => 'Mes réservations';

  @override
  String get myProfile => 'Mon profil';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleReceptionist => 'Réceptionniste';

  @override
  String get roleClient => 'Client';

  @override
  String get settings => 'Paramètres';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get language => 'Langue';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'Anglais';
}
