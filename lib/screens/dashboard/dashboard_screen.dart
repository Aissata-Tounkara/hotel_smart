import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/utilisateur.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/statistics_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_strings.dart';
import '../../utils/ui_helpers.dart';

/// Tableau de bord principal. Le contenu (menu, statistiques) s'adapte au
/// role de l'utilisateur connecte via [AuthProvider] (point 30).
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatisticsProvider>().charger();
      context.read<NotificationProvider>().rafraichir();
    });
  }

  Future<void> _deconnecter(BuildContext context) async {
    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final utilisateur = authProvider.utilisateurCourant;
    final arabe = settingsProvider.estArabe;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('tableau_de_bord', arabe: arabe)),
        actions: [
          if (authProvider.peutGererOperations)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  tooltip: 'Notifications',
                  onPressed: () => _afficherNotifications(context, notificationProvider),
                ),
                if (notificationProvider.alertesNonLues.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text(
                        '${notificationProvider.alertesNonLues.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppStrings.get('deconnexion', arabe: arabe),
            onPressed: () => _deconnecter(context),
          ),
        ],
      ),
      body: utilisateur == null
          ? const Center(child: Text('Aucun utilisateur connecte'))
          : RefreshIndicator(
              onRefresh: () => context.read<StatisticsProvider>().charger(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _EnteteBienvenue(utilisateur: utilisateur, arabe: arabe),
                  if (authProvider.peutGererOperations) ...[
                    const SizedBox(height: 24),
                    const _CartesStatistiques(),
                  ],
                  const SizedBox(height: 24),
                  Text(AppStrings.get('acces_rapide', arabe: arabe), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _MenuRole(authProvider: authProvider, arabe: arabe),
                ],
              ),
            ),
    );
  }

  void _afficherNotifications(BuildContext context, NotificationProvider notificationProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final alertes = notificationProvider.alertesNonLues;
        return SafeArea(
          child: alertes.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Aucune notification non lue'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: alertes.length,
                  itemBuilder: (context, i) {
                    final alerte = alertes[i];
                    return ListTile(
                      leading: Icon(alerte.type.name == 'checkIn' ? Icons.login : Icons.logout),
                      title: Text(alerte.titre),
                      subtitle: Text(alerte.message),
                      trailing: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () => notificationProvider.marquerCommeLue(alerte.id!),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _CartesStatistiques extends StatelessWidget {
  const _CartesStatistiques();

  @override
  Widget build(BuildContext context) {
    final statisticsProvider = context.watch<StatisticsProvider>();
    final stats = statisticsProvider.statistiques;

    if (statisticsProvider.enChargement && stats == null) {
      return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
    }
    if (stats == null) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _CarteStat('Chambres disponibles', '${stats.chambresDisponibles}', Icons.check_circle_outline, Colors.green),
        _CarteStat('Chambres occupees', '${stats.chambresOccupees}', Icons.hotel, Colors.orange),
        _CarteStat('Reservations du jour', '${stats.reservationsDuJour}', Icons.event_available, Colors.blue),
        _CarteStat('CA du mois', UiHelpers.formatMontant(stats.chiffreAffairesMensuel), Icons.trending_up, Colors.purple),
      ],
    );
  }
}

class _CarteStat extends StatelessWidget {
  final String titre;
  final String valeur;
  final IconData icone;
  final Color couleur;
  const _CarteStat(this.titre, this.valeur, this.icone, this.couleur);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, color: couleur),
            const SizedBox(height: 6),
            Text(valeur, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(titre, style: Theme.of(context).textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _EnteteBienvenue extends StatelessWidget {
  final Utilisateur utilisateur;
  final bool arabe;
  const _EnteteBienvenue({required this.utilisateur, required this.arabe});

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
                  Text('${AppStrings.get('bienvenue', arabe: arabe)}, ${utilisateur.nom}',
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
  final bool arabe;
  const _MenuRole({required this.authProvider, required this.arabe});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      if (authProvider.peutGererOperations) ...[
        _MenuItem(AppStrings.get('chambres', arabe: arabe), Icons.bed_outlined, AppRoutes.rooms),
        _MenuItem(AppStrings.get('reservations', arabe: arabe), Icons.calendar_month_outlined, AppRoutes.reservations),
        _MenuItem(AppStrings.get('clients', arabe: arabe), Icons.people_outline, AppRoutes.clients),
        _MenuItem(AppStrings.get('paiements', arabe: arabe), Icons.payments_outlined, AppRoutes.payments),
      ],
      if (authProvider.estAdmin) ...[
        _MenuItem(AppStrings.get('utilisateurs', arabe: arabe), Icons.admin_panel_settings_outlined, AppRoutes.users),
        _MenuItem(AppStrings.get('statistiques', arabe: arabe), Icons.bar_chart_outlined, AppRoutes.statistics),
      ],
      if (authProvider.estClient) ...[
        _MenuItem(AppStrings.get('mes_reservations', arabe: arabe), Icons.event_note_outlined, AppRoutes.myReservations),
      ],
      _MenuItem(AppStrings.get('mon_profil', arabe: arabe), Icons.person_outline, AppRoutes.profile),
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
                  onTap: () => Navigator.of(context).pushNamed(item.route),
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
  final String route;
  const _MenuItem(this.libelle, this.icone, this.route);
}
