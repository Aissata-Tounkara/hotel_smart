import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';

/// Ecran de demarrage : verifie s'il existe deja une session utilisateur
/// (SharedPreferences) avant de rediriger vers le login ou le dashboard.
/// Reprend l'habillage bleu nuit/or de l'ecran de connexion.
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
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: AppTheme.degradeBleuNuit),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(gradient: AppTheme.degradeOr, shape: BoxShape.circle),
                child: const Icon(Icons.hotel, color: AppTheme.bleuNuitProfond, size: 40),
              ),
              const SizedBox(height: 18),
              Text(
                'HOTEL SMART',
                style: AppTheme.playfair(
                  color: AppTheme.ivoire,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(height: 32),
              const SpinKitThreeBounce(color: AppTheme.or, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
