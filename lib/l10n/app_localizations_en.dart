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
}
