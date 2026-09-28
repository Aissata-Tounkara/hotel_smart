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

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @apply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get reset;

  /// No description provided for @filters.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get filters;

  /// No description provided for @viewList.
  ///
  /// In fr, this message translates to:
  /// **'Vue liste'**
  String get viewList;

  /// No description provided for @viewCards.
  ///
  /// In fr, this message translates to:
  /// **'Vue cartes'**
  String get viewCards;

  /// No description provided for @searchRooms.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher par numéro ou type'**
  String get searchRooms;

  /// No description provided for @noRoomsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune chambre trouvée'**
  String get noRoomsFound;

  /// No description provided for @deleteRoomTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la chambre'**
  String get deleteRoomTitle;

  /// No description provided for @deleteRoomConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la chambre {number} ? Cette action est irréversible.'**
  String deleteRoomConfirmation(String number);

  /// No description provided for @addRoom.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une chambre'**
  String get addRoom;

  /// No description provided for @roomNumberField.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de chambre'**
  String get roomNumberField;

  /// No description provided for @roomNumber.
  ///
  /// In fr, this message translates to:
  /// **'Chambre {number}'**
  String roomNumber(String number);

  /// No description provided for @roomNumberType.
  ///
  /// In fr, this message translates to:
  /// **'Chambre {number} - {type}'**
  String roomNumberType(String number, String type);

  /// No description provided for @roomPriceAndFloor.
  ///
  /// In fr, this message translates to:
  /// **'{price} / nuit - étage {floor}'**
  String roomPriceAndFloor(String price, String floor);

  /// No description provided for @roomSemanticSummary.
  ///
  /// In fr, this message translates to:
  /// **'Chambre {number}, type {type}, {status}, {price} par nuit, étage {floor}'**
  String roomSemanticSummary(
    String number,
    String type,
    String status,
    String price,
    String floor,
  );

  /// No description provided for @roomTypeField.
  ///
  /// In fr, this message translates to:
  /// **'Type de chambre'**
  String get roomTypeField;

  /// No description provided for @roomStatusField.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get roomStatusField;

  /// No description provided for @roomPriceField.
  ///
  /// In fr, this message translates to:
  /// **'Prix par nuit (DA)'**
  String get roomPriceField;

  /// No description provided for @roomFloorField.
  ///
  /// In fr, this message translates to:
  /// **'Étage'**
  String get roomFloorField;

  /// No description provided for @roomDescriptionOptional.
  ///
  /// In fr, this message translates to:
  /// **'Description (optionnel)'**
  String get roomDescriptionOptional;

  /// No description provided for @newRoom.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle chambre'**
  String get newRoom;

  /// No description provided for @editRoom.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la chambre'**
  String get editRoom;

  /// No description provided for @duplicateRoomNumber.
  ///
  /// In fr, this message translates to:
  /// **'Une chambre avec ce numéro existe déjà'**
  String get duplicateRoomNumber;

  /// No description provided for @roomLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les chambres'**
  String get roomLoadError;

  /// No description provided for @roomSaveError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’enregistrer la chambre'**
  String get roomSaveError;

  /// No description provided for @roomUpdateError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de modifier la chambre'**
  String get roomUpdateError;

  /// No description provided for @roomDeleteError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de supprimer la chambre'**
  String get roomDeleteError;

  /// No description provided for @filterRooms.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer les chambres'**
  String get filterRooms;

  /// No description provided for @allRoomTypes.
  ///
  /// In fr, this message translates to:
  /// **'Tous les types'**
  String get allRoomTypes;

  /// No description provided for @allRoomStatuses.
  ///
  /// In fr, this message translates to:
  /// **'Tous les statuts'**
  String get allRoomStatuses;

  /// No description provided for @priceRange.
  ///
  /// In fr, this message translates to:
  /// **'Prix : {start} - {end} DA'**
  String priceRange(String start, String end);

  /// No description provided for @roomTypeSingle.
  ///
  /// In fr, this message translates to:
  /// **'Simple'**
  String get roomTypeSingle;

  /// No description provided for @roomTypeDouble.
  ///
  /// In fr, this message translates to:
  /// **'Double'**
  String get roomTypeDouble;

  /// No description provided for @roomTypeSuite.
  ///
  /// In fr, this message translates to:
  /// **'Suite'**
  String get roomTypeSuite;

  /// No description provided for @roomStatusAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get roomStatusAvailable;

  /// No description provided for @roomStatusOccupied.
  ///
  /// In fr, this message translates to:
  /// **'Occupée'**
  String get roomStatusOccupied;

  /// No description provided for @roomStatusMaintenance.
  ///
  /// In fr, this message translates to:
  /// **'Maintenance'**
  String get roomStatusMaintenance;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Le champ {field} est obligatoire'**
  String requiredField(String field);

  /// No description provided for @positiveNumberField.
  ///
  /// In fr, this message translates to:
  /// **'Le champ {field} doit être un nombre positif'**
  String positiveNumberField(String field);

  /// No description provided for @clientSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher par nom, téléphone ou email'**
  String get clientSearch;

  /// No description provided for @noClientsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun client trouvé'**
  String get noClientsFound;

  /// No description provided for @deleteClientTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le client'**
  String get deleteClientTitle;

  /// No description provided for @deleteClientConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer {name} ? Cette action est irréversible.'**
  String deleteClientConfirmation(String name);

  /// No description provided for @deleteClientTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le client {name}'**
  String deleteClientTooltip(String name);

  /// No description provided for @clientSemanticSummary.
  ///
  /// In fr, this message translates to:
  /// **'Client {name}, téléphone {phone}, nationalité {nationality}'**
  String clientSemanticSummary(String name, String phone, String nationality);

  /// No description provided for @clientSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{phone} - {nationality}'**
  String clientSubtitle(String phone, String nationality);

  /// No description provided for @addClient.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un client'**
  String get addClient;

  /// No description provided for @newClient.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau client'**
  String get newClient;

  /// No description provided for @editClient.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le client'**
  String get editClient;

  /// No description provided for @firstName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get lastName;

  /// No description provided for @phone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phone;

  /// No description provided for @phoneInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Format de téléphone invalide'**
  String get phoneInvalid;

  /// No description provided for @cinPassportOptional.
  ///
  /// In fr, this message translates to:
  /// **'CIN / Passeport (optionnel)'**
  String get cinPassportOptional;

  /// No description provided for @nationality.
  ///
  /// In fr, this message translates to:
  /// **'Nationalité'**
  String get nationality;

  /// No description provided for @selectNationality.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une nationalité'**
  String get selectNationality;

  /// No description provided for @loadingNationalities.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des nationalités...'**
  String get loadingNationalities;

  /// No description provided for @nationalitiesOffline.
  ///
  /// In fr, this message translates to:
  /// **'Liste hors ligne (service indisponible) : options limitées'**
  String get nationalitiesOffline;

  /// No description provided for @clientLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les clients'**
  String get clientLoadError;

  /// No description provided for @clientSaveError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’enregistrer le client'**
  String get clientSaveError;

  /// No description provided for @clientUpdateError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de modifier le client'**
  String get clientUpdateError;

  /// No description provided for @clientDeleteError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de supprimer le client : il possède peut-être des réservations'**
  String get clientDeleteError;

  /// No description provided for @unknownError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur inconnue'**
  String get unknownError;

  /// No description provided for @statisticsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get statisticsTitle;

  /// No description provided for @revenueThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Chiffre d’affaires du mois'**
  String get revenueThisMonth;

  /// No description provided for @occupancyByMonth.
  ///
  /// In fr, this message translates to:
  /// **'Taux d’occupation par mois'**
  String get occupancyByMonth;

  /// No description provided for @revenueByRoomType.
  ///
  /// In fr, this message translates to:
  /// **'Revenus par type de chambre'**
  String get revenueByRoomType;

  /// No description provided for @noData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée'**
  String get noData;

  /// No description provided for @occupancyChartSummary.
  ///
  /// In fr, this message translates to:
  /// **'Graphique du taux d’occupation par mois. {summary}.'**
  String occupancyChartSummary(String summary);

  /// No description provided for @revenueChartSummary.
  ///
  /// In fr, this message translates to:
  /// **'Graphique des revenus par type de chambre. {summary}.'**
  String revenueChartSummary(String summary);

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get profileTitle;

  /// No description provided for @profileUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour avec succès'**
  String get profileUpdated;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get name;

  /// No description provided for @fullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get fullName;

  /// No description provided for @profileNewPasswordOptional.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe (optionnel)'**
  String get profileNewPasswordOptional;

  /// No description provided for @confirmPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPassword;

  /// No description provided for @logoutLabel.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logoutLabel;

  /// No description provided for @personalAccountCannotDelete.
  ///
  /// In fr, this message translates to:
  /// **'Vous ne pouvez pas supprimer votre propre compte'**
  String get personalAccountCannotDelete;

  /// No description provided for @deleteUserTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l’utilisateur'**
  String get deleteUserTitle;

  /// No description provided for @deleteUserConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte de {name} ?'**
  String deleteUserConfirmation(String name);

  /// No description provided for @deleteUserTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte de {name}'**
  String deleteUserTooltip(String name);

  /// No description provided for @noUsers.
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur'**
  String get noUsers;

  /// No description provided for @newUser.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel utilisateur'**
  String get newUser;

  /// No description provided for @editUser.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l’utilisateur'**
  String get editUser;

  /// No description provided for @role.
  ///
  /// In fr, this message translates to:
  /// **'Rôle'**
  String get role;

  /// No description provided for @clientRecordToLink.
  ///
  /// In fr, this message translates to:
  /// **'Fiche client à lier'**
  String get clientRecordToLink;

  /// No description provided for @clientLinkHelp.
  ///
  /// In fr, this message translates to:
  /// **'La fiche client doit déjà exister (créée par le réceptionniste)'**
  String get clientLinkHelp;

  /// No description provided for @selectClientRecord.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une fiche client'**
  String get selectClientRecord;

  /// No description provided for @reservationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get reservationsTitle;

  /// No description provided for @myReservationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes réservations'**
  String get myReservationsTitle;

  /// No description provided for @allReservations.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get allReservations;

  /// No description provided for @reservationSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher par client ou chambre'**
  String get reservationSearch;

  /// No description provided for @noReservationsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation trouvée'**
  String get noReservationsFound;

  /// No description provided for @confirmCheckIn.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer l’arrivée du client et occuper la chambre ?'**
  String get confirmCheckIn;

  /// No description provided for @confirmCheckOut.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le départ du client et libérer la chambre ?'**
  String get confirmCheckOut;

  /// No description provided for @confirmCancelReservation.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir annuler cette réservation ?'**
  String get confirmCancelReservation;

  /// No description provided for @checkIn.
  ///
  /// In fr, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In fr, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @room.
  ///
  /// In fr, this message translates to:
  /// **'Chambre'**
  String get room;

  /// No description provided for @availableRoomsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Chambres disponibles'**
  String get availableRoomsLabel;

  /// No description provided for @noRoomsAvailableDates.
  ///
  /// In fr, this message translates to:
  /// **'Aucune chambre disponible pour ces dates'**
  String get noRoomsAvailableDates;

  /// No description provided for @totalAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant total'**
  String get totalAmount;

  /// No description provided for @reservationConfirmAction.
  ///
  /// In fr, this message translates to:
  /// **'CONFIRMER LA RÉSERVATION'**
  String get reservationConfirmAction;

  /// No description provided for @completeAllFields.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez compléter tous les champs'**
  String get completeAllFields;

  /// No description provided for @selectReservation.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une réservation'**
  String get selectReservation;

  /// No description provided for @newPayment.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau paiement'**
  String get newPayment;

  /// No description provided for @newReservation.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle réservation'**
  String get newReservation;

  /// No description provided for @reservation.
  ///
  /// In fr, this message translates to:
  /// **'Réservation'**
  String get reservation;

  /// No description provided for @paymentAmount.
  ///
  /// In fr, this message translates to:
  /// **'Montant (DA)'**
  String get paymentAmount;

  /// No description provided for @paymentMethod.
  ///
  /// In fr, this message translates to:
  /// **'Méthode de paiement'**
  String get paymentMethod;

  /// No description provided for @paymentStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get paymentStatus;

  /// No description provided for @paymentNotRecorded.
  ///
  /// In fr, this message translates to:
  /// **'Aucun paiement enregistré'**
  String get paymentNotRecorded;

  /// No description provided for @userAccountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur {name}'**
  String userAccountLabel(String name);

  /// No description provided for @cancelReservationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get cancelReservationTitle;

  /// No description provided for @unknownClient.
  ///
  /// In fr, this message translates to:
  /// **'Client inconnu'**
  String get unknownClient;

  /// No description provided for @accountNotLinkedToClient.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte n’est lié à aucune fiche client. Contactez la réception.'**
  String get accountNotLinkedToClient;

  /// No description provided for @reservationSemanticSummary.
  ///
  /// In fr, this message translates to:
  /// **'Réservation de {client}, chambre {room}, du {arrival} au {departure}, {nights} nuits, {amount}, statut {status}'**
  String reservationSemanticSummary(
    String client,
    String room,
    String arrival,
    String departure,
    String nights,
    String amount,
    String status,
  );

  /// No description provided for @arrivalDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d’arrivée'**
  String get arrivalDate;

  /// No description provided for @departureDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de départ'**
  String get departureDate;

  /// No description provided for @roomPricePerNight.
  ///
  /// In fr, this message translates to:
  /// **'{price} / nuit'**
  String roomPricePerNight(String price);

  /// No description provided for @addReservation.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une réservation'**
  String get addReservation;

  /// No description provided for @addPayment.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un paiement'**
  String get addPayment;

  /// No description provided for @addUser.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un utilisateur'**
  String get addUser;

  /// No description provided for @reservationNumber.
  ///
  /// In fr, this message translates to:
  /// **'Réservation n° {number}'**
  String reservationNumber(String number);

  /// No description provided for @paymentSemanticSummary.
  ///
  /// In fr, this message translates to:
  /// **'Paiement de {client}, {amount}, méthode {method}, le {date}, statut {status}'**
  String paymentSemanticSummary(
    String client,
    String amount,
    String method,
    String date,
    String status,
  );

  /// No description provided for @checkInTodayTitle.
  ///
  /// In fr, this message translates to:
  /// **'Check-in aujourd’hui'**
  String get checkInTodayTitle;

  /// No description provided for @checkInDueMessage.
  ///
  /// In fr, this message translates to:
  /// **'Un client est attendu aujourd’hui pour son arrivée (réservation n° {number}).'**
  String checkInDueMessage(String number);

  /// No description provided for @checkOutTodayTitle.
  ///
  /// In fr, this message translates to:
  /// **'Check-out aujourd’hui'**
  String get checkOutTodayTitle;

  /// No description provided for @checkOutDueMessage.
  ///
  /// In fr, this message translates to:
  /// **'Un client doit libérer sa chambre aujourd’hui (réservation n° {number}).'**
  String checkOutDueMessage(String number);
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
