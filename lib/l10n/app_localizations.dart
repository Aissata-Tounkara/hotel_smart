import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @showPassword.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get hidePassword;

  /// No description provided for @emailRequired.
  ///
  /// In fr, this message translates to:
  /// **'L\'email est obligatoire'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Format email invalide'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe est obligatoire'**
  String get passwordRequired;

  /// No description provided for @authNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte ne correspond à cet email'**
  String get authNoAccount;

  /// No description provided for @authWrongPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe incorrect'**
  String get authWrongPassword;

  /// No description provided for @authUnexpected.
  ///
  /// In fr, this message translates to:
  /// **'Erreur inattendue : impossible de se connecter'**
  String get authUnexpected;

  /// No description provided for @dashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboard;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @markNotificationRead.
  ///
  /// In fr, this message translates to:
  /// **'Marquer la notification comme lue'**
  String get markNotificationRead;

  /// No description provided for @noUnreadNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification non lue'**
  String get noUnreadNotifications;

  /// No description provided for @noUserSignedIn.
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur connecté'**
  String get noUserSignedIn;

  /// No description provided for @welcomeUser.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue, {name}'**
  String welcomeUser(String name);

  /// No description provided for @quickAccess.
  ///
  /// In fr, this message translates to:
  /// **'Accès rapide'**
  String get quickAccess;

  /// No description provided for @monthlyRevenue.
  ///
  /// In fr, this message translates to:
  /// **'Chiffre d’affaires du mois'**
  String get monthlyRevenue;

  /// No description provided for @occupancyRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux d’occupation'**
  String get occupancyRate;

  /// No description provided for @availableRooms.
  ///
  /// In fr, this message translates to:
  /// **'Disponibles'**
  String get availableRooms;

  /// No description provided for @occupiedRooms.
  ///
  /// In fr, this message translates to:
  /// **'Occupées'**
  String get occupiedRooms;

  /// No description provided for @todayReservations.
  ///
  /// In fr, this message translates to:
  /// **'Réservations du jour'**
  String get todayReservations;

  /// No description provided for @rooms.
  ///
  /// In fr, this message translates to:
  /// **'Chambres'**
  String get rooms;

  /// No description provided for @reservations.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get reservations;

  /// No description provided for @clients.
  ///
  /// In fr, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @payments.
  ///
  /// In fr, this message translates to:
  /// **'Paiements'**
  String get payments;

  /// No description provided for @users.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateurs'**
  String get users;

  /// No description provided for @statistics.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get statistics;

  /// No description provided for @myReservations.
  ///
  /// In fr, this message translates to:
  /// **'Mes réservations'**
  String get myReservations;

  /// No description provided for @myProfile.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get myProfile;

  /// No description provided for @roleAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Administrateur'**
  String get roleAdmin;

  /// No description provided for @roleReceptionist.
  ///
  /// In fr, this message translates to:
  /// **'Réceptionniste'**
  String get roleReceptionist;

  /// No description provided for @roleClient.
  ///
  /// In fr, this message translates to:
  /// **'Client'**
  String get roleClient;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get themeSystem;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @languageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get languageEnglish;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
