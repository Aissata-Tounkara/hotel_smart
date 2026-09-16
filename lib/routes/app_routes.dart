import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/clients/client_list_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/payments/payment_list_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/reservations/my_reservations_screen.dart';
import '../screens/reservations/reservation_list_screen.dart';
import '../screens/rooms/room_list_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/statistics/statistics_screen.dart';
import '../screens/users/user_list_screen.dart';

/// Table de navigation nommee centralisee. Chaque ecran ajoute au fil du
/// projet doit y declarer sa route pour eviter les `Navigator.push` directs
/// disperses dans le code.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String rooms = '/rooms';
  static const String reservations = '/reservations';
  static const String clients = '/clients';
  static const String users = '/users';
  static const String myReservations = '/my-reservations';
  static const String payments = '/payments';
  static const String statistics = '/statistics';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    dashboard: (context) => const DashboardScreen(),
    rooms: (context) => const RoomListScreen(),
    reservations: (context) => const ReservationListScreen(),
    clients: (context) => const ClientListScreen(),
    users: (context) => const UserListScreen(),
    myReservations: (context) => const MyReservationsScreen(),
    payments: (context) => const PaymentListScreen(),
    statistics: (context) => const StatisticsScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
