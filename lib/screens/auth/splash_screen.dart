import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';

/// Ecran de demarrage : verifie s'il existe deja une session utilisateur
/// (SharedPreferences) avant de rediriger vers le login ou le dashboard.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _demarrer());
  }

  Future<void> _demarrer() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.tenterRestaurationSession();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(
      authProvider.estConnecte ? AppRoutes.dashboard : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bleuNuit,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hotel, color: AppTheme.or, size: 72),
            const SizedBox(height: 16),
            const Text(
              'Hotel Smart',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const SpinKitThreeBounce(color: AppTheme.or, size: 28),
          ],
        ),
      ),
    );
  }
}
