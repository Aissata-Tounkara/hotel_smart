import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chambre.dart';
import '../../models/reservation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/room_provider.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/premium_app_bar.dart';
import '../../widgets/premium_list_tile.dart';
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
      appBar: const PremiumAppBar(title: 'Mes reservations'),
      body: FadeSlideIn(
        child: _enChargement
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
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: _reservations!.length,
                          itemBuilder: (context, i) {
                            final reservation = _reservations![i];
                            final chambre = chambresParId[reservation.chambreId];
                            return PremiumListTile(
                              icon: Icons.meeting_room_outlined,
                              title: 'Chambre ${chambre?.numero ?? '-'} - ${chambre?.type.libelle ?? ''}',
                              subtitle:
                                  '${UiHelpers.formatDate(reservation.dateArrivee)} -> ${UiHelpers.formatDate(reservation.dateDepart)} - ${UiHelpers.formatMontant(reservation.montantTotal)}',
                              trailing: StatusBadge(
                                texte: reservation.statut.libelle,
                                couleur: UiHelpers.couleurStatutReservation(reservation.statut),
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}
