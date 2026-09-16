import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/art_deco_fan.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/ornamental_divider.dart';

/// Ecran de connexion : porte d'entree de l'identite de marque Hotel
/// Smart, toujours affichee dans l'habillage bleu nuit/or (independant du
/// choix clair/sombre de l'utilisateur, qui n'intervient qu'apres
/// connexion).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _motDePasseVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    final succes = await authProvider.login(
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    if (succes) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        backgroundColor: AppTheme.bleuNuitProfond,
        body: Stack(
          children: [
            const DecoratedBox(decoration: BoxDecoration(gradient: AppTheme.degradeBleuNuit)),
            Positioned(
              bottom: -40,
              left: 0,
              right: 0,
              child: Center(
                child: ArtDecoFan(size: 340, color: AppTheme.or),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: FadeSlideIn(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  gradient: AppTheme.degradeOr,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.hotel, color: AppTheme.bleuNuitProfond, size: 42),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'HOTEL SMART',
                              textAlign: TextAlign.center,
                              style: AppTheme.playfair(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.ivoire,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'LE PALACE · ALGER',
                              textAlign: TextAlign.center,
                              style: AppTheme.manrope(
                                color: AppTheme.orLumineux,
                                fontSize: 12,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const OrnamentalDivider(),
                            AppTextField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              controller: _passwordController,
                              label: 'Mot de passe',
                              icon: Icons.lock_outline,
                              obscureText: !_motDePasseVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _motDePasseVisible ? Icons.visibility_off : Icons.visibility,
                                  color: AppTheme.or,
                                ),
                                onPressed: () => setState(() => _motDePasseVisible = !_motDePasseVisible),
                              ),
                              validator: (v) => Validators.required(v, champ: 'Le mot de passe'),
                              onFieldSubmitted: (_) => _seConnecter(),
                            ),
                            if (authProvider.erreur != null) ...[
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.bordeaux.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppTheme.bordeaux.withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline, color: AppTheme.dangerClair, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authProvider.erreur!,
                                        style: AppTheme.manrope(color: AppTheme.dangerClair),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 32),
                            GradientButton(
                              label: 'SE CONNECTER',
                              loading: authProvider.enChargement,
                              onPressed: _seConnecter,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
