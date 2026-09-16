import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client.dart';
import '../../models/chambre.dart';
import '../../models/reservation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/room_provider.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
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
    final confirme = await afficherConfirmation(
      context,
      titre: 'Check-in',
      message: 'Confirmer l\'arrivee du client et occuper la chambre ?',
    );
    if (!confirme || !mounted) return;
    await context.read<ReservationProvider>().effectuerCheckIn(reservation);
  }

  Future<void> _checkOut(Reservation reservation) async {
    final confirme = await afficherConfirmation(
      context,
      titre: 'Check-out',
      message: 'Confirmer le depart du client et liberer la chambre ?',
    );
    if (!confirme || !mounted) return;
    await context.read<ReservationProvider>().effectuerCheckOut(reservation);
  }

  Future<void> _annuler(Reservation reservation) async {
    final confirme = await afficherConfirmation(
      context,
      titre: 'Annuler la reservation',
      message: 'Etes-vous sur de vouloir annuler cette reservation ?',
      destructif: true,
    );
    if (!confirme || !mounted) return;
    await context.read<ReservationProvider>().annuler(reservation);
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = context.watch<ReservationProvider>();
    final clientProvider = context.watch<ClientProvider>();
    final roomProvider = context.watch<RoomProvider>();
    final authProvider = context.watch<AuthProvider>();

    final clientsParId = {for (final c in clientProvider.clients) c.id: c};
    final chambresParId = {for (final c in roomProvider.chambres) c.id: c};

    var reservations = reservationProvider.reservations;
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
      appBar: AppBar(title: const Text('Reservations')),
      floatingActionButton: authProvider.peutGererOperations
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReservationFormScreen()),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher par client ou chambre...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (v) => setState(() => _recherche = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ChipStatut(label: 'Toutes', selectionne: reservationProvider.filtreStatut == null,
                      onTap: () => reservationProvider.filtrerParStatut(null)),
                  ...StatutReservation.values.map((s) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _ChipStatut(
                          label: s.libelle,
                          selectionne: reservationProvider.filtreStatut == s,
                          onTap: () => reservationProvider.filtrerParStatut(s),
                        ),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: reservationProvider.enChargement
                ? const Center(child: CircularProgressIndicator())
                : reservations.isEmpty
                    ? const EmptyState(icone: Icons.event_busy, message: 'Aucune reservation trouvee')
                    : RefreshIndicator(
                        onRefresh: reservationProvider.charger,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: reservations.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final reservation = reservations[i];
                            final client = clientsParId[reservation.clientId];
                            final chambre = chambresParId[reservation.chambreId];
                            return _CarteReservation(
                              reservation: reservation,
                              client: client,
                              chambre: chambre,
                              peutGerer: authProvider.peutGererOperations,
                              onCheckIn: () => _checkIn(reservation),
                              onCheckOut: () => _checkOut(reservation),
                              onAnnuler: () => _annuler(reservation),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _ChipStatut extends StatelessWidget {
  final String label;
  final bool selectionne;
  final VoidCallback onTap;
  const _ChipStatut({required this.label, required this.selectionne, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(label: Text(label), selected: selectionne, onSelected: (_) => onTap());
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    client?.nomComplet ?? 'Client inconnu',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                StatusBadge(
                  texte: reservation.statut.libelle,
                  couleur: UiHelpers.couleurStatutReservation(reservation.statut),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('Chambre ${chambre?.numero ?? '-'} - ${chambre?.type.libelle ?? ''}'),
            Text('${UiHelpers.formatDate(reservation.dateArrivee)} -> ${UiHelpers.formatDate(reservation.dateDepart)} (${reservation.dureeSejour} nuits)'),
            const SizedBox(height: 4),
            Text(UiHelpers.formatMontant(reservation.montantTotal), style: const TextStyle(fontWeight: FontWeight.bold)),
            if (peutGerer) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  if (reservation.statut == StatutReservation.enAttente) ...[
                    FilledButton.tonalIcon(
                      onPressed: onCheckIn,
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Check-in'),
                    ),
                    OutlinedButton.icon(
                      onPressed: onAnnuler,
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('Annuler'),
                    ),
                  ],
                  if (reservation.statut == StatutReservation.confirmee)
                    FilledButton.tonalIcon(
                      onPressed: onCheckOut,
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Check-out'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
