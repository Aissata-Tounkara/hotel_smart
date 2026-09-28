import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/client.dart';
import '../../models/chambre.dart';
import '../../models/reservation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/room_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/premium_app_bar.dart';
import '../../widgets/status_badge.dart';
import 'reservation_form_screen.dart';

/// Liste des reservations avec filtrage par statut et recherche, ainsi que
/// les actions de check-in / check-out et d'annulation (points 24, 25).
class ReservationListScreen extends StatefulWidget {
  const ReservationListScreen({super.key});

  @override
  State<ReservationListScreen> createState() => _ReservationListScreenState();
}

class _ReservationListScreenState extends State<ReservationListScreen> {
  String _recherche = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReservationProvider>().charger();
      context.read<ClientProvider>().charger();
      context.read<RoomProvider>().charger();
    });
  }

  Future<void> _checkIn(Reservation reservation) async {
    final l10n = AppLocalizations.of(context)!;
    final confirme = await afficherConfirmation(
      context,
      titre: l10n.checkIn,
      message: l10n.confirmCheckIn,
    );
    if (!confirme || !mounted) return;
    await context.read<ReservationProvider>().effectuerCheckIn(reservation);
  }

  Future<void> _checkOut(Reservation reservation) async {
    final l10n = AppLocalizations.of(context)!;
    final confirme = await afficherConfirmation(
      context,
      titre: l10n.checkOut,
      message: l10n.confirmCheckOut,
    );
    if (!confirme || !mounted) return;
    await context.read<ReservationProvider>().effectuerCheckOut(reservation);
  }

  Future<void> _annuler(Reservation reservation) async {
    final l10n = AppLocalizations.of(context)!;
    final confirme = await afficherConfirmation(
      context,
      titre: l10n.cancelReservationTitle,
      message: l10n.confirmCancelReservation,
      destructif: true,
    );
    if (!confirme || !mounted) return;
    await context.read<ReservationProvider>().annuler(reservation);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reservationsSource = context
        .select<ReservationProvider, List<Reservation>>(
          (provider) => provider.reservations,
        );
    final enChargement = context.select<ReservationProvider, bool>(
      (provider) => provider.enChargement,
    );
    final filtreStatut = context
        .select<ReservationProvider, StatutReservation?>(
          (provider) => provider.filtreStatut,
        );
    final clients = context.select<ClientProvider, List<Client>>(
      (provider) => provider.clients,
    );
    final chambres = context.select<RoomProvider, List<Chambre>>(
      (provider) => provider.chambres,
    );
    final peutGerer = context.select<AuthProvider, bool>(
      (provider) => provider.peutGererOperations,
    );
    final reservationProvider = context.read<ReservationProvider>();

    final clientsParId = {for (final c in clients) c.id: c};
    final chambresParId = {for (final c in chambres) c.id: c};

    var reservations = reservationsSource;
    if (_recherche.isNotEmpty) {
      final q = _recherche.toLowerCase();
      reservations = reservations.where((r) {
        final client = clientsParId[r.clientId];
        final chambre = chambresParId[r.chambreId];
        return (client?.nomComplet.toLowerCase().contains(q) ?? false) ||
            (chambre?.numero.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    return Scaffold(
      appBar: PremiumAppBar(title: l10n.reservationsTitle),
      floatingActionButton: peutGerer
          ? FloatingActionButton(
              tooltip: l10n.addReservation,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ReservationFormScreen(),
                ),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      body: FadeSlideIn(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: AppTextField(
                label: l10n.reservationSearch,
                icon: Icons.search,
                onChanged: (v) => setState(() => _recherche = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _ChipStatut(
                      label: l10n.allReservations,
                      selectionne: filtreStatut == null,
                      onTap: () => reservationProvider.filtrerParStatut(null),
                    ),
                    ...StatutReservation.values.map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _ChipStatut(
                          label: s.libelle,
                          selectionne: filtreStatut == s,
                          onTap: () => reservationProvider.filtrerParStatut(s),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: enChargement
                  ? const Center(child: CircularProgressIndicator())
                  : reservations.isEmpty
                  ? EmptyState(
                      icone: Icons.event_busy,
                      message: l10n.noReservationsFound,
                    )
                  : RefreshIndicator(
                      onRefresh: reservationProvider.charger,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: reservations.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final reservation = reservations[i];
                          final client = clientsParId[reservation.clientId];
                          final chambre = chambresParId[reservation.chambreId];
                          return Semantics(
                            key: ValueKey('reservation-${reservation.id}'),
                            label: l10n.reservationSemanticSummary(
                              client?.nomComplet ?? l10n.unknownClient,
                              chambre?.numero ?? '-',
                              UiHelpers.formatDate(reservation.dateArrivee),
                              UiHelpers.formatDate(reservation.dateDepart),
                              reservation.dureeSejour.toString(),
                              UiHelpers.formatMontant(reservation.montantTotal),
                              reservation.statut.libelle,
                            ),
                            child: _CarteReservation(
                              reservation: reservation,
                              client: client,
                              chambre: chambre,
                              peutGerer: peutGerer,
                              onCheckIn: () => _checkIn(reservation),
                              onCheckOut: () => _checkOut(reservation),
                              onAnnuler: () => _annuler(reservation),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChipStatut extends StatelessWidget {
  final String label;
  final bool selectionne;
  final VoidCallback onTap;
  const _ChipStatut({
    required this.label,
    required this.selectionne,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selectionne,
      onSelected: (_) => onTap(),
    );
  }
}

class _CarteReservation extends StatelessWidget {
  final Reservation reservation;
  final Client? client;
  final Chambre? chambre;
  final bool peutGerer;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final VoidCallback onAnnuler;

  const _CarteReservation({
    required this.reservation,
    required this.client,
    required this.chambre,
    required this.peutGerer,
    required this.onCheckIn,
    required this.onCheckOut,
    required this.onAnnuler,
  });

  @override
  Widget build(BuildContext context) {
    final or = Theme.of(context).colorScheme.secondary;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: or.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  client?.nomComplet ?? 'Client inconnu',
                  style: AppTheme.playfair(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              StatusBadge(
                texte: reservation.statut.libelle,
                couleur: UiHelpers.couleurStatutReservation(reservation.statut),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Chambre ${chambre?.numero ?? '-'} - ${chambre?.type.libelle ?? ''}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '${UiHelpers.formatDate(reservation.dateArrivee)} -> ${UiHelpers.formatDate(reservation.dateDepart)} (${reservation.dureeSejour} nuits)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 6),
          Text(
            UiHelpers.formatMontant(reservation.montantTotal),
            style: AppTheme.manrope(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          if (peutGerer) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                if (reservation.statut == StatutReservation.enAttente) ...[
                  FilledButton.tonalIcon(
                    onPressed: onCheckIn,
                    icon: const Icon(Icons.login, size: 18),
                    label: Text(AppLocalizations.of(context)!.checkIn),
                  ),
                  OutlinedButton.icon(
                    onPressed: onAnnuler,
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ],
                if (reservation.statut == StatutReservation.confirmee)
                  FilledButton.tonalIcon(
                    onPressed: onCheckOut,
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text(AppLocalizations.of(context)!.checkOut),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
