import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
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
      nouveauMotDePasse: _nouveauMotDePasseController.text.isEmpty
          ? null
          : _nouveauMotDePasseController.text,
    );
    if (!mounted) return;
    setState(() => _enEnregistrement = false);
    if (succes) {
      _nouveauMotDePasseController.clear();
      _confirmationController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.erreur ?? AppLocalizations.of(context)!.unknownError,
          ),
        ),
      );
      authProvider.effacerErreur();
    }
  }

  Future<void> _deconnecter() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final utilisateur = context.select<AuthProvider, Utilisateur?>(
      (provider) => provider.utilisateurCourant,
    );
    final or = Theme.of(context).colorScheme.secondary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PremiumAppBar(
        title: l10n.profileTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settings,
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
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
                  decoration: const BoxDecoration(
                    gradient: AppTheme.degradeOr,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    (utilisateur?.nom.isNotEmpty ?? false)
                        ? utilisateur!.nom[0].toUpperCase()
                        : '?',
                    style: AppTheme.playfair(
                      fontSize: 34,
                      color: AppTheme.bleuNuitProfond,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
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
                label: l10n.name,
                icon: Icons.person_outline,
                validator: (v) => Validators.required(v, champ: l10n.name),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _emailController,
                label: l10n.email,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const OrnamentalDivider(),
              AppTextField(
                controller: _nouveauMotDePasseController,
                label: l10n.profileNewPasswordOptional,
                icon: Icons.lock_outline,
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? null : Validators.password(v),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _confirmationController,
                label: l10n.confirmPassword,
                icon: Icons.lock_outline,
                obscureText: true,
                validator: (v) {
                  if (_nouveauMotDePasseController.text.isEmpty) return null;
                  return Validators.confirmPassword(
                    v,
                    _nouveauMotDePasseController.text,
                  );
                },
              ),
              const SizedBox(height: 28),
              GradientButton(
                label: l10n.save.toUpperCase(),
                loading: _enEnregistrement,
                onPressed: _enregistrer,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _deconnecter,
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                ),
                label: Text(
                  l10n.logoutLabel,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
