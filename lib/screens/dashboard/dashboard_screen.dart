import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/utilisateur.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/statistics_provider.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_theme.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/hero_stat_card.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';

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
      appBar: PremiumAppBar(
        title: AppStrings.get('tableau_de_bord', arabe: arabe),
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
                      decoration: const BoxDecoration(color: AppTheme.bordeaux, shape: BoxShape.circle),
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
              child: FadeSlideIn(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _EnteteBienvenue(utilisateur: utilisateur, arabe: arabe),
                    if (authProvider.peutGererOperations) ...[
                      const OrnamentalDivider(),
                      const _StatistiquesDashboard(),
                    ],
                    const OrnamentalDivider(),
                    Text(
                      AppStrings.get('acces_rapide', arabe: arabe),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),
                    _MenuRole(authProvider: authProvider, arabe: arabe),
                  ],
                ),
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
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Aucune notification non lue', style: AppTheme.manrope()),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: alertes.length,
                  itemBuilder: (context, i) {
                    final alerte = alertes[i];
                    return ListTile(
                      leading: Icon(
                        alerte.type.name == 'checkIn' ? Icons.login : Icons.logout,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(alerte.titre, style: AppTheme.manrope(fontWeight: FontWeight.w700)),
                      subtitle: Text(alerte.message, style: AppTheme.manrope(fontSize: 12.5)),
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

class _StatistiquesDashboard extends StatelessWidget {
  const _StatistiquesDashboard();

  @override
  Widget build(BuildContext context) {
    final statisticsProvider = context.watch<StatisticsProvider>();
    final stats = statisticsProvider.statistiques;

    if (statisticsProvider.enChargement && stats == null) {
      return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
    }
    if (stats == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeroStatCard(
          label: 'Chiffre d\'affaires du mois',
          value: UiHelpers.formatMontant(stats.chiffreAffairesMensuel),
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            MiniStat(label: 'Disponibles', value: '${stats.chambresDisponibles}', icon: Icons.check_circle_outline),
            MiniStat(label: 'Occupees', value: '${stats.chambresOccupees}', icon: Icons.hotel),
            MiniStat(label: 'Reservations du jour', value: '${stats.reservationsDuJour}', icon: Icons.event_available),
          ],
        ),
      ],
    );
  }
}

class _EnteteBienvenue extends StatelessWidget {
  final Utilisateur utilisateur;
  final bool arabe;
  const _EnteteBienvenue({required this.utilisateur, required this.arabe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final or = theme.colorScheme.secondary;
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(gradient: AppTheme.degradeOr, borderRadius: BorderRadius.circular(4)),
          child: Text(
            utilisateur.nom.isNotEmpty ? utilisateur.nom[0].toUpperCase() : '?',
            style: AppTheme.playfair(color: AppTheme.bleuNuitProfond, fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.get('bienvenue', arabe: arabe)}, ${utilisateur.nom}',
                style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 2),
              Text(
                utilisateur.role.libelle,
                style: AppTheme.manrope(color: or, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
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

    final or = Theme.of(context).colorScheme.secondary;
    final couleurTexte = Theme.of(context).textTheme.bodyLarge?.color ?? AppTheme.encre;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: items
          .map((item) => InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () => Navigator.of(context).pushNamed(item.route),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: or.withValues(alpha: 0.35)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icone, size: 28, color: or),
                      const SizedBox(height: 8),
                      Text(
                        item.libelle,
                        textAlign: TextAlign.center,
                        style: AppTheme.manrope(fontWeight: FontWeight.w600, fontSize: 13, color: couleurTexte),
                      ),
                    ],
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
