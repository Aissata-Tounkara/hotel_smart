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

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get retry => 'Réessayer';

  @override
  String get apply => 'Appliquer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get filters => 'Filtres';

  @override
  String get viewList => 'Vue liste';

  @override
  String get viewCards => 'Vue cartes';

  @override
  String get searchRooms => 'Rechercher par numéro ou type';

  @override
  String get noRoomsFound => 'Aucune chambre trouvée';

  @override
  String get deleteRoomTitle => 'Supprimer la chambre';

  @override
  String deleteRoomConfirmation(String number) {
    return 'Supprimer la chambre $number ? Cette action est irréversible.';
  }

  @override
  String get addRoom => 'Ajouter une chambre';

  @override
  String get roomNumberField => 'Numéro de chambre';

  @override
  String roomNumber(String number) {
    return 'Chambre $number';
  }

  @override
  String roomNumberType(String number, String type) {
    return 'Chambre $number - $type';
  }

  @override
  String roomPriceAndFloor(String price, String floor) {
    return '$price / nuit - étage $floor';
  }

  @override
  String roomSemanticSummary(
    String number,
    String type,
    String status,
    String price,
    String floor,
  ) {
    return 'Chambre $number, type $type, $status, $price par nuit, étage $floor';
  }

  @override
  String get roomTypeField => 'Type de chambre';

  @override
  String get roomStatusField => 'Statut';

  @override
  String get roomPriceField => 'Prix par nuit (DA)';

  @override
  String get roomFloorField => 'Étage';

  @override
  String get roomDescriptionOptional => 'Description (optionnel)';

  @override
  String get newRoom => 'Nouvelle chambre';

  @override
  String get editRoom => 'Modifier la chambre';

  @override
  String get duplicateRoomNumber => 'Une chambre avec ce numéro existe déjà';

  @override
  String get roomLoadError => 'Impossible de charger les chambres';

  @override
  String get roomSaveError => 'Impossible d’enregistrer la chambre';

  @override
  String get roomUpdateError => 'Impossible de modifier la chambre';

  @override
  String get roomDeleteError => 'Impossible de supprimer la chambre';

  @override
  String get filterRooms => 'Filtrer les chambres';

  @override
  String get allRoomTypes => 'Tous les types';

  @override
  String get allRoomStatuses => 'Tous les statuts';

  @override
  String priceRange(String start, String end) {
    return 'Prix : $start - $end DA';
  }

  @override
  String get roomTypeSingle => 'Simple';

  @override
  String get roomTypeDouble => 'Double';

  @override
  String get roomTypeSuite => 'Suite';

  @override
  String get roomStatusAvailable => 'Disponible';

  @override
  String get roomStatusOccupied => 'Occupée';

  @override
  String get roomStatusMaintenance => 'Maintenance';

  @override
  String requiredField(String field) {
    return 'Le champ $field est obligatoire';
  }

  @override
  String positiveNumberField(String field) {
    return 'Le champ $field doit être un nombre positif';
  }

  @override
  String get clientSearch => 'Rechercher par nom, téléphone ou email';

  @override
  String get noClientsFound => 'Aucun client trouvé';

  @override
  String get deleteClientTitle => 'Supprimer le client';

  @override
  String deleteClientConfirmation(String name) {
    return 'Supprimer $name ? Cette action est irréversible.';
  }

  @override
  String deleteClientTooltip(String name) {
    return 'Supprimer le client $name';
  }

  @override
  String clientSemanticSummary(String name, String phone, String nationality) {
    return 'Client $name, téléphone $phone, nationalité $nationality';
  }

  @override
  String clientSubtitle(String phone, String nationality) {
    return '$phone - $nationality';
  }

  @override
  String get addClient => 'Ajouter un client';

  @override
  String get newClient => 'Nouveau client';

  @override
  String get editClient => 'Modifier le client';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get phone => 'Téléphone';

  @override
  String get phoneInvalid => 'Format de téléphone invalide';

  @override
  String get cinPassportOptional => 'CIN / Passeport (optionnel)';

  @override
  String get nationality => 'Nationalité';

  @override
  String get selectNationality => 'Veuillez sélectionner une nationalité';

  @override
  String get loadingNationalities => 'Chargement des nationalités...';

  @override
  String get nationalitiesOffline =>
      'Liste hors ligne (service indisponible) : options limitées';

  @override
  String get clientLoadError => 'Impossible de charger les clients';

  @override
  String get clientSaveError => 'Impossible d’enregistrer le client';

  @override
  String get clientUpdateError => 'Impossible de modifier le client';

  @override
  String get clientDeleteError =>
      'Impossible de supprimer le client : il possède peut-être des réservations';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get statisticsTitle => 'Statistiques';

  @override
  String get revenueThisMonth => 'Chiffre d’affaires du mois';

  @override
  String get occupancyByMonth => 'Taux d’occupation par mois';

  @override
  String get revenueByRoomType => 'Revenus par type de chambre';

  @override
  String get noData => 'Aucune donnée';

  @override
  String occupancyChartSummary(String summary) {
    return 'Graphique du taux d’occupation par mois. $summary.';
  }

  @override
  String revenueChartSummary(String summary) {
    return 'Graphique des revenus par type de chambre. $summary.';
  }

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès';

  @override
  String get name => 'Nom';

  @override
  String get fullName => 'Nom complet';

  @override
  String get profileNewPasswordOptional => 'Nouveau mot de passe (optionnel)';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get logoutLabel => 'Déconnexion';

  @override
  String get personalAccountCannotDelete =>
      'Vous ne pouvez pas supprimer votre propre compte';

  @override
  String get deleteUserTitle => 'Supprimer l’utilisateur';

  @override
  String deleteUserConfirmation(String name) {
    return 'Supprimer le compte de $name ?';
  }

  @override
  String deleteUserTooltip(String name) {
    return 'Supprimer le compte de $name';
  }

  @override
  String get noUsers => 'Aucun utilisateur';

  @override
  String get newUser => 'Nouvel utilisateur';

  @override
  String get editUser => 'Modifier l’utilisateur';

  @override
  String get role => 'Rôle';

  @override
  String get clientRecordToLink => 'Fiche client à lier';

  @override
  String get clientLinkHelp =>
      'La fiche client doit déjà exister (créée par le réceptionniste)';

  @override
  String get selectClientRecord => 'Veuillez sélectionner une fiche client';

  @override
  String get reservationsTitle => 'Réservations';

  @override
  String get myReservationsTitle => 'Mes réservations';

  @override
  String get allReservations => 'Toutes';

  @override
  String get reservationSearch => 'Rechercher par client ou chambre';

  @override
  String get noReservationsFound => 'Aucune réservation trouvée';

  @override
  String get confirmCheckIn =>
      'Confirmer l’arrivée du client et occuper la chambre ?';

  @override
  String get confirmCheckOut =>
      'Confirmer le départ du client et libérer la chambre ?';

  @override
  String get confirmCancelReservation =>
      'Êtes-vous sûr de vouloir annuler cette réservation ?';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get room => 'Chambre';

  @override
  String get availableRoomsLabel => 'Chambres disponibles';

  @override
  String get noRoomsAvailableDates =>
      'Aucune chambre disponible pour ces dates';

  @override
  String get totalAmount => 'Montant total';

  @override
  String get reservationConfirmAction => 'CONFIRMER LA RÉSERVATION';

  @override
  String get completeAllFields => 'Veuillez compléter tous les champs';

  @override
  String get selectReservation => 'Veuillez sélectionner une réservation';

  @override
  String get newPayment => 'Nouveau paiement';

  @override
  String get newReservation => 'Nouvelle réservation';

  @override
  String get reservation => 'Réservation';

  @override
  String get paymentAmount => 'Montant (DA)';

  @override
  String get paymentMethod => 'Méthode de paiement';

  @override
  String get paymentStatus => 'Statut';

  @override
  String get paymentNotRecorded => 'Aucun paiement enregistré';

  @override
  String userAccountLabel(String name) {
    return 'Utilisateur $name';
  }

  @override
  String get cancelReservationTitle => 'Annuler la réservation';

  @override
  String get unknownClient => 'Client inconnu';

  @override
  String get accountNotLinkedToClient =>
      'Votre compte n’est lié à aucune fiche client. Contactez la réception.';

  @override
  String reservationSemanticSummary(
    String client,
    String room,
    String arrival,
    String departure,
    String nights,
    String amount,
    String status,
  ) {
    return 'Réservation de $client, chambre $room, du $arrival au $departure, $nights nuits, $amount, statut $status';
  }

  @override
  String get arrivalDate => 'Date d’arrivée';

  @override
  String get departureDate => 'Date de départ';

  @override
  String roomPricePerNight(String price) {
    return '$price / nuit';
  }

  @override
  String get addReservation => 'Ajouter une réservation';

  @override
  String get addPayment => 'Ajouter un paiement';

  @override
  String get addUser => 'Ajouter un utilisateur';

  @override
  String reservationNumber(String number) {
    return 'Réservation n° $number';
  }

  @override
  String paymentSemanticSummary(
    String client,
    String amount,
    String method,
    String date,
    String status,
  ) {
    return 'Paiement de $client, $amount, méthode $method, le $date, statut $status';
  }

  @override
  String get checkInTodayTitle => 'Check-in aujourd’hui';

  @override
  String checkInDueMessage(String number) {
    return 'Un client est attendu aujourd’hui pour son arrivée (réservation n° $number).';
  }

  @override
  String get checkOutTodayTitle => 'Check-out aujourd’hui';

  @override
  String checkOutDueMessage(String number) {
    return 'Un client doit libérer sa chambre aujourd’hui (réservation n° $number).';
  }
}
