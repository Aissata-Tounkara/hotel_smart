import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/utilisateur.dart';
import '../../models/notification_alerte.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/statistics_provider.dart';
import '../../routes/app_routes.dart';
import '../../services/statistics_service.dart';
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
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final utilisateur = context.select<AuthProvider, Utilisateur?>(
      (provider) => provider.utilisateurCourant,
    );
    final peutGerer = context.select<AuthProvider, bool>(
      (provider) => provider.peutGererOperations,
    );
    final alertes = context
        .select<NotificationProvider, List<NotificationAlerte>>(
          (provider) => provider.alertesNonLues,
        );
    final notificationProvider = context.read<NotificationProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PremiumAppBar(
        title: l10n.dashboard,
        actions: [
          if (peutGerer)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  tooltip: l10n.notifications,
                  onPressed: () => _afficherNotifications(
                    context,
                    notificationProvider,
                    l10n,
                  ),
                ),
                if (alertes.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.bordeaux,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${alertes.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () => _deconnecter(context),
          ),
        ],
      ),
      body: utilisateur == null
          ? Center(child: Text(l10n.noUserSignedIn))
          : RefreshIndicator(
              onRefresh: () => Future.wait([
                context.read<StatisticsProvider>().charger(),
                context.read<NotificationProvider>().rafraichir(),
              ]),
              child: FadeSlideIn(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _EnteteBienvenue(utilisateur: utilisateur, l10n: l10n),
                    if (peutGerer) ...[
                      const OrnamentalDivider(),
                      const _StatistiquesDashboard(),
                    ],
                    const OrnamentalDivider(),
                    Text(
                      l10n.quickAccess,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),
                    _MenuRole(l10n: l10n),
                  ],
                ),
              ),
            ),
    );
  }

  void _afficherNotifications(
    BuildContext context,
    NotificationProvider notificationProvider,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final alertes = notificationProvider.alertesNonLues;
        return SafeArea(
          child: alertes.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.noUnreadNotifications,
                    style: AppTheme.manrope(),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: alertes.length,
                  itemBuilder: (context, i) {
                    final alerte = alertes[i];
                    return ListTile(
                      leading: Icon(
                        alerte.type.name == 'checkIn'
                            ? Icons.login
                            : Icons.logout,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      title: Text(
                        alerte.type == TypeNotification.checkIn
                            ? l10n.checkInTodayTitle
                            : l10n.checkOutTodayTitle,
                        style: AppTheme.manrope(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        alerte.type == TypeNotification.checkIn
                            ? l10n.checkInDueMessage(
                                alerte.reservationId.toString(),
                              )
                            : l10n.checkOutDueMessage(
                                alerte.reservationId.toString(),
                              ),
                        style: AppTheme.manrope(fontSize: 12.5),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check),
                        tooltip: l10n.markNotificationRead,
                        onPressed: () =>
                            notificationProvider.marquerCommeLue(alerte.id!),
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
    final stats = context.select<StatisticsProvider, Statistique?>(
      (provider) => provider.statistiques,
    );
    final enChargement = context.select<StatisticsProvider, bool>(
      (provider) => provider.enChargement,
    );
    final l10n = AppLocalizations.of(context)!;

    if (enChargement && stats == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (stats == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeroStatCard(
          label: l10n.monthlyRevenue,
          value: UiHelpers.formatMontant(stats.chiffreAffairesMensuel),
          icon: Icons.trending_up,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            MiniStat(
              label: l10n.availableRooms,
              value: '${stats.chambresDisponibles}',
              icon: Icons.check_circle_outline,
            ),
            MiniStat(
              label: l10n.occupiedRooms,
              value: '${stats.chambresOccupees}',
              icon: Icons.hotel,
            ),
            MiniStat(
              label: l10n.todayReservations,
              value: '${stats.reservationsDuJour}',
              icon: Icons.event_available,
            ),
          ],
        ),
      ],
    );
  }
}

class _EnteteBienvenue extends StatelessWidget {
  final Utilisateur utilisateur;
  final AppLocalizations l10n;
  const _EnteteBienvenue({required this.utilisateur, required this.l10n});

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
          decoration: BoxDecoration(
            gradient: AppTheme.degradeOr,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            utilisateur.nom.isNotEmpty ? utilisateur.nom[0].toUpperCase() : '?',
            style: AppTheme.playfair(
              color: AppTheme.bleuNuitProfond,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.welcomeUser(utilisateur.nom),
                style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 6),
              Container(
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
                  switch (utilisateur.role) {
                    RoleUtilisateur.admin => l10n.roleAdmin,
                    RoleUtilisateur.receptionniste => l10n.roleReceptionist,
                    RoleUtilisateur.client => l10n.roleClient,
                  },
                  style: AppTheme.manrope(
                    color: theme.textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuRole extends StatelessWidget {
  final AppLocalizations l10n;
  const _MenuRole({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final peutGerer = context.select<AuthProvider, bool>(
      (provider) => provider.peutGererOperations,
    );
    final estAdmin = context.select<AuthProvider, bool>(
      (provider) => provider.estAdmin,
    );
    final estClient = context.select<AuthProvider, bool>(
      (provider) => provider.estClient,
    );
    final items = <_MenuItem>[
      if (peutGerer) ...[
        _MenuItem(l10n.rooms, Icons.bed_outlined, AppRoutes.rooms),
        _MenuItem(
          l10n.reservations,
          Icons.calendar_month_outlined,
          AppRoutes.reservations,
        ),
        _MenuItem(l10n.clients, Icons.people_outline, AppRoutes.clients),
        _MenuItem(l10n.payments, Icons.payments_outlined, AppRoutes.payments),
      ],
      if (estAdmin) ...[
        _MenuItem(
          l10n.users,
          Icons.admin_panel_settings_outlined,
          AppRoutes.users,
        ),
        _MenuItem(
          l10n.statistics,
          Icons.bar_chart_outlined,
          AppRoutes.statistics,
        ),
      ],
      if (estClient) ...[
        _MenuItem(
          l10n.myReservations,
          Icons.event_note_outlined,
          AppRoutes.myReservations,
        ),
      ],
      _MenuItem(l10n.myProfile, Icons.person_outline, AppRoutes.profile),
    ];

    final or = Theme.of(context).colorScheme.secondary;
    final couleurTexte =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppTheme.encre;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: items
          .map(
            (item) => InkWell(
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
                      style: AppTheme.manrope(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: couleurTexte,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
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
