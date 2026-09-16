import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/utilisateur.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

/// Tableau de bord principal. Le contenu (menu, statistiques) s'adapte au
/// role de l'utilisateur connecte via [AuthProvider].
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _deconnecter(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final utilisateur = authProvider.utilisateurCourant;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Deconnexion',
            onPressed: () => _deconnecter(context),
          ),
        ],
      ),
      body: utilisateur == null
          ? const Center(child: Text('Aucun utilisateur connecte'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _EnteteBienvenue(utilisateur: utilisateur),
                const SizedBox(height: 24),
                Text('Acces rapide', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                _MenuRole(authProvider: authProvider),
              ],
            ),
    );
  }
}

class _EnteteBienvenue extends StatelessWidget {
  final Utilisateur utilisateur;
  const _EnteteBienvenue({required this.utilisateur});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                utilisateur.nom.isNotEmpty ? utilisateur.nom[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bienvenue, ${utilisateur.nom}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(utilisateur.role.libelle,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuRole extends StatelessWidget {
  final AuthProvider authProvider;
  const _MenuRole({required this.authProvider});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      if (authProvider.peutGererOperations) ...[
        _MenuItem('Chambres', Icons.bed_outlined, AppRoutes.rooms),
        _MenuItem('Reservations', Icons.calendar_month_outlined, AppRoutes.reservations),
        _MenuItem('Clients', Icons.people_outline, AppRoutes.clients),
        const _MenuItem('Paiements', Icons.payments_outlined, null),
      ],
      if (authProvider.estAdmin) ...[
        _MenuItem('Utilisateurs', Icons.admin_panel_settings_outlined, AppRoutes.users),
        const _MenuItem('Statistiques', Icons.bar_chart_outlined, null),
      ],
      if (authProvider.estClient) ...[
        _MenuItem('Mes reservations', Icons.event_note_outlined, AppRoutes.myReservations),
      ],
      const _MenuItem('Mon profil', Icons.person_outline, null),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: items
          .map((item) => Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    if (item.route != null) {
                      Navigator.of(context).pushNamed(item.route!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.libelle} — bientot disponible')),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icone, size: 32, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 8),
                        Text(item.libelle, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _MenuItem {
  final String libelle;
  final IconData icone;
  final String? route;
  const _MenuItem(this.libelle, this.icone, this.route);
}
