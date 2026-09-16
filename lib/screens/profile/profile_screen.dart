import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/utilisateur.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/validators.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  (utilisateur?.nom.isNotEmpty ?? false) ? utilisateur!.nom[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(utilisateur?.role.libelle ?? '', style: Theme.of(context).textTheme.bodyMedium),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom', prefixIcon: Icon(Icons.person_outline)),
              validator: (v) => Validators.required(v, champ: 'Le nom'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nouveauMotDePasseController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe (optionnel)',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (v) => v == null || v.isEmpty ? null : Validators.password(v),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmationController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmer le mot de passe',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (v) {
                if (_nouveauMotDePasseController.text.isEmpty) return null;
                return Validators.confirmPassword(v, _nouveauMotDePasseController.text);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _enEnregistrement ? null : _enregistrer,
                child: _enEnregistrement
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Enregistrer'),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _deconnecter,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Deconnexion', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
