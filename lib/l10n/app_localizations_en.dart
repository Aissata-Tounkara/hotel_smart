// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Invalid email format';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get authNoAccount => 'No account matches this email';

  @override
  String get authWrongPassword => 'Incorrect password';

  @override
  String get authUnexpected => 'Unexpected error: unable to sign in';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get logout => 'Log out';

  @override
  String get notifications => 'Notifications';

  @override
  String get markNotificationRead => 'Mark notification as read';

  @override
  String get noUnreadNotifications => 'No unread notifications';

  @override
  String get noUserSignedIn => 'No user is signed in';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String get quickAccess => 'Quick access';

  @override
  String get monthlyRevenue => 'Revenue this month';

  @override
  String get occupancyRate => 'Occupancy rate';

  @override
  String get availableRooms => 'Available rooms';

  @override
  String get occupiedRooms => 'Occupied rooms';

  @override
  String get todayReservations => 'Today’s reservations';

  @override
  String get rooms => 'Rooms';

  @override
  String get reservations => 'Reservations';

  @override
  String get clients => 'Guests';

  @override
  String get payments => 'Payments';

  @override
  String get users => 'Users';

  @override
  String get statistics => 'Statistics';

  @override
  String get myReservations => 'My reservations';

  @override
  String get myProfile => 'My profile';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleReceptionist => 'Receptionist';

  @override
  String get roleClient => 'Guest';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get language => 'Language';

  @override
  String get languageFrench => 'French';

  @override
  String get languageEnglish => 'English';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get filters => 'Filters';

  @override
  String get viewList => 'List view';

  @override
  String get viewCards => 'Card view';

  @override
  String get searchRooms => 'Search by room number or type';

  @override
  String get noRoomsFound => 'No rooms found';

  @override
  String get deleteRoomTitle => 'Delete room';

  @override
  String deleteRoomConfirmation(String number) {
    return 'Delete room $number? This action cannot be undone.';
  }

  @override
  String get addRoom => 'Add room';

  @override
  String get roomNumberField => 'Room number';

  @override
  String roomNumber(String number) {
    return 'Room $number';
  }

  @override
  String roomNumberType(String number, String type) {
    return 'Room $number - $type';
  }

  @override
  String roomPriceAndFloor(String price, String floor) {
    return '$price / night - floor $floor';
  }

  @override
  String roomSemanticSummary(
    String number,
    String type,
    String status,
    String price,
    String floor,
  ) {
    return 'Room $number, $type, $status, $price per night, floor $floor';
  }

  @override
  String get roomTypeField => 'Room type';

  @override
  String get roomStatusField => 'Status';

  @override
  String get roomPriceField => 'Price per night (DZD)';

  @override
  String get roomFloorField => 'Floor';

  @override
  String get roomDescriptionOptional => 'Description (optional)';

  @override
  String get newRoom => 'New room';

  @override
  String get editRoom => 'Edit room';

  @override
  String get duplicateRoomNumber => 'A room with this number already exists';

  @override
  String get roomLoadError => 'Unable to load rooms';

  @override
  String get roomSaveError => 'Unable to save the room';

  @override
  String get roomUpdateError => 'Unable to update the room';

  @override
  String get roomDeleteError => 'Unable to delete the room';

  @override
  String get filterRooms => 'Filter rooms';

  @override
  String get allRoomTypes => 'All types';

  @override
  String get allRoomStatuses => 'All statuses';

  @override
  String priceRange(String start, String end) {
    return 'Price: $start - $end DZD';
  }

  @override
  String get roomTypeSingle => 'Single';

  @override
  String get roomTypeDouble => 'Double';

  @override
  String get roomTypeSuite => 'Suite';

  @override
  String get roomStatusAvailable => 'Available';

  @override
  String get roomStatusOccupied => 'Occupied';

  @override
  String get roomStatusMaintenance => 'Maintenance';

  @override
  String requiredField(String field) {
    return '$field is required';
  }

  @override
  String positiveNumberField(String field) {
    return '$field must be a positive number';
  }

  @override
  String get clientSearch => 'Search by name, phone, or email';

  @override
  String get noClientsFound => 'No guests found';

  @override
  String get deleteClientTitle => 'Delete guest';

  @override
  String deleteClientConfirmation(String name) {
    return 'Delete $name? This action cannot be undone.';
  }

  @override
  String deleteClientTooltip(String name) {
    return 'Delete guest $name';
  }

  @override
  String clientSemanticSummary(String name, String phone, String nationality) {
    return 'Guest $name, phone $phone, nationality $nationality';
  }

  @override
  String clientSubtitle(String phone, String nationality) {
    return '$phone - $nationality';
  }

  @override
  String get addClient => 'Add guest';

  @override
  String get newClient => 'New guest';

  @override
  String get editClient => 'Edit guest';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get phone => 'Phone';

  @override
  String get phoneInvalid => 'Invalid phone format';

  @override
  String get cinPassportOptional => 'ID / Passport (optional)';

  @override
  String get nationality => 'Nationality';

  @override
  String get selectNationality => 'Please select a nationality';

  @override
  String get loadingNationalities => 'Loading nationalities...';

  @override
  String get nationalitiesOffline =>
      'Offline list (service unavailable): limited options';

  @override
  String get clientLoadError => 'Unable to load guests';

  @override
  String get clientSaveError => 'Unable to save the guest';

  @override
  String get clientUpdateError => 'Unable to update the guest';

  @override
  String get clientDeleteError =>
      'Unable to delete the guest: they may have reservations';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get revenueThisMonth => 'Revenue this month';

  @override
  String get occupancyByMonth => 'Monthly occupancy rate';

  @override
  String get revenueByRoomType => 'Revenue by room type';

  @override
  String get noData => 'No data';

  @override
  String occupancyChartSummary(String summary) {
    return 'Monthly occupancy rate chart. $summary.';
  }

  @override
  String revenueChartSummary(String summary) {
    return 'Revenue by room type chart. $summary.';
  }

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get name => 'Name';

  @override
  String get fullName => 'Full name';

  @override
  String get profileNewPasswordOptional => 'New password (optional)';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get logoutLabel => 'Sign out';

  @override
  String get personalAccountCannotDelete =>
      'You cannot delete your own account';

  @override
  String get deleteUserTitle => 'Delete user';

  @override
  String deleteUserConfirmation(String name) {
    return 'Delete the account for $name?';
  }

  @override
  String deleteUserTooltip(String name) {
    return 'Delete the account for $name';
  }

  @override
  String get noUsers => 'No users';

  @override
  String get newUser => 'New user';

  @override
  String get editUser => 'Edit user';

  @override
  String get role => 'Role';

  @override
  String get clientRecordToLink => 'Guest record to link';

  @override
  String get clientLinkHelp =>
      'The guest record must already exist (created by the receptionist)';

  @override
  String get selectClientRecord => 'Please select a guest record';

  @override
  String get reservationsTitle => 'Reservations';

  @override
  String get myReservationsTitle => 'My reservations';

  @override
  String get allReservations => 'All';

  @override
  String get reservationSearch => 'Search by guest or room';

  @override
  String get noReservationsFound => 'No reservations found';

  @override
  String get confirmCheckIn =>
      'Confirm the guest’s arrival and occupy the room?';

  @override
  String get confirmCheckOut =>
      'Confirm the guest’s departure and release the room?';

  @override
  String get confirmCancelReservation =>
      'Are you sure you want to cancel this reservation?';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get room => 'Room';

  @override
  String get availableRoomsLabel => 'Available rooms';

  @override
  String get noRoomsAvailableDates => 'No rooms available for these dates';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get reservationConfirmAction => 'CONFIRM RESERVATION';

  @override
  String get completeAllFields => 'Please complete all fields';

  @override
  String get selectReservation => 'Please select a reservation';

  @override
  String get newPayment => 'New payment';

  @override
  String get newReservation => 'New reservation';

  @override
  String get reservation => 'Reservation';

  @override
  String get paymentAmount => 'Amount (DZD)';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get paymentStatus => 'Status';

  @override
  String get paymentNotRecorded => 'No payments recorded';

  @override
  String userAccountLabel(String name) {
    return 'User $name';
  }

  @override
  String get cancelReservationTitle => 'Cancel reservation';

  @override
  String get unknownClient => 'Unknown guest';

  @override
  String get accountNotLinkedToClient =>
      'Your account is not linked to a guest record. Contact reception.';

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
    return 'Reservation for $client, room $room, from $arrival to $departure, $nights nights, $amount, status $status';
  }

  @override
  String get arrivalDate => 'Arrival date';

  @override
  String get departureDate => 'Departure date';

  @override
  String roomPricePerNight(String price) {
    return '$price / night';
  }

  @override
  String get addReservation => 'Add reservation';

  @override
  String get addPayment => 'Add payment';

  @override
  String get addUser => 'Add user';

  @override
  String reservationNumber(String number) {
    return 'Reservation # $number';
  }

  @override
  String paymentSemanticSummary(
    String client,
    String amount,
    String method,
    String date,
    String status,
  ) {
    return 'Payment from $client, $amount, method $method, on $date, status $status';
  }

  @override
  String get checkInTodayTitle => 'Check-in today';

  @override
  String checkInDueMessage(String number) {
    return 'A guest is expected today (reservation # $number).';
  }

  @override
  String get checkOutTodayTitle => 'Check-out today';

  @override
  String checkOutDueMessage(String number) {
    return 'A guest should check out today (reservation # $number).';
  }
}
