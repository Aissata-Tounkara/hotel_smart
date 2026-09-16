import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';

/// Table de navigation nommee centralisee. Chaque ecran ajoute au fil du
/// projet doit y declarer sa route pour eviter les `Navigator.push` directs
/// disperses dans le code.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    dashboard: (context) => const DashboardScreen(),
  };
}
