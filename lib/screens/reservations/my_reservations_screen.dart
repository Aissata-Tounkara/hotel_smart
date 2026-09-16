import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chambre.dart';
import '../../models/reservation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/room_provider.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_badge.dart';

/// Ecran reserve au role Client : consultation de ses propres reservations
/// uniquement, jamais celles des autres clients (point 15 - permissions).
class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  List<Reservation>? _reservations;
  bool _enChargement = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _charger());
  }

  Future<void> _charger() async {
    final authProvider = context.read<AuthProvider>();
    final clientId = authProvider.utilisateurCourant?.clientId;
    await context.read<RoomProvider>().charger();
    if (!mounted) return;
    if (clientId != null) {
      final reservations = await context.read<ReservationProvider>().getReservationsClient(clientId);
      if (!mounted) return;
      setState(() {
        _reservations = reservations;
        _enChargement = false;
      });
    } else {
      setState(() => _enChargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final roomProvider = context.watch<RoomProvider>();
    final chambresParId = {for (final c in roomProvider.chambres) c.id: c};
    final clientId = authProvider.utilisateurCourant?.clientId;

    return Scaffold(
      appBar: AppBar(title: const Text('Mes reservations')),
      body: _enChargement
          ? const Center(child: CircularProgressIndicator())
          : clientId == null
              ? const EmptyState(
                  icone: Icons.link_off,
                  message: 'Votre compte n\'est relie a aucune fiche client.\nContactez la reception.',
                )
              : (_reservations == null || _reservations!.isEmpty)
                  ? const EmptyState(icone: Icons.event_busy, message: 'Vous n\'avez aucune reservation')
                  : RefreshIndicator(
                      onRefresh: _charger,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: _reservations!.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final reservation = _reservations![i];
                          final chambre = chambresParId[reservation.chambreId];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.meeting_room_outlined),
                              title: Text('Chambre ${chambre?.numero ?? '-'} - ${chambre?.type.libelle ?? ''}'),
                              subtitle: Text(
                                '${UiHelpers.formatDate(reservation.dateArrivee)} -> ${UiHelpers.formatDate(reservation.dateDepart)}\n${UiHelpers.formatMontant(reservation.montantTotal)}',
                              ),
                              isThreeLine: true,
                              trailing: StatusBadge(
                                texte: reservation.statut.libelle,
                                couleur: UiHelpers.couleurStatutReservation(reservation.statut),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
