import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/utilisateur.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';
import '../settings/settings_screen.dart';

/// Ecran de profil : modification du nom, de l'email et du mot de passe
/// (avec confirmation), acces aux parametres et deconnexion (point 34).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _emailController;
  final _nouveauMotDePasseController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _enEnregistrement = false;

  @override
  void initState() {
    super.initState();
    final utilisateur = context.read<AuthProvider>().utilisateurCourant;
    _nomController = TextEditingController(text: utilisateur?.nom ?? '');
    _emailController = TextEditingController(text: utilisateur?.email ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _nouveauMotDePasseController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enEnregistrement = true);
    final authProvider = context.read<AuthProvider>();
    final succes = await authProvider.mettreAJourProfil(
      nom: _nomController.text,
      email: _emailController.text,
      nouveauMotDePasse: _nouveauMotDePasseController.text.isEmpty ? null : _nouveauMotDePasseController.text,
    );
    if (!mounted) return;
    setState(() => _enEnregistrement = false);
    if (succes) {
      _nouveauMotDePasseController.clear();
      _confirmationController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis a jour avec succes')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.erreur ?? 'Erreur inconnue')),
      );
      authProvider.effacerErreur();
    }
  }

  Future<void> _deconnecter() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final utilisateur = authProvider.utilisateurCourant;
    final or = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Mon profil',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Parametres',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: FadeSlideIn(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 84,
                  height: 84,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(gradient: AppTheme.degradeOr, shape: BoxShape.circle),
                  child: Text(
                    (utilisateur?.nom.isNotEmpty ?? false) ? utilisateur!.nom[0].toUpperCase() : '?',
                    style: AppTheme.playfair(fontSize: 34, color: AppTheme.bleuNuitProfond),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: or.withValues(alpha: 0.12),
                    border: Border.all(color: or.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    utilisateur?.role.libelle ?? '',
                    style: AppTheme.manrope(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const OrnamentalDivider(),
              AppTextField(
                controller: _nomController,
                label: 'Nom',
                icon: Icons.person_outline,
                validator: (v) => Validators.required(v, champ: 'Le nom'),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const OrnamentalDivider(),
              AppTextField(
                controller: _nouveauMotDePasseController,
                label: 'Nouveau mot de passe (optionnel)',
                icon: Icons.lock_outline,
                obscureText: true,
                validator: (v) => v == null || v.isEmpty ? null : Validators.password(v),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _confirmationController,
                label: 'Confirmer le mot de passe',
                icon: Icons.lock_outline,
                obscureText: true,
                validator: (v) {
                  if (_nouveauMotDePasseController.text.isEmpty) return null;
                  return Validators.confirmPassword(v, _nouveauMotDePasseController.text);
                },
              ),
              const SizedBox(height: 28),
              GradientButton(
                label: 'ENREGISTRER',
                loading: _enEnregistrement,
                onPressed: _enregistrer,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _deconnecter,
                icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                label: Text('Deconnexion', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                style: OutlinedButton.styleFrom(side: BorderSide(color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
