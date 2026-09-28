import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
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
      final reservations = await context
          .read<ReservationProvider>()
          .getReservationsClient(clientId);
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
    final l10n = AppLocalizations.of(context)!;
    final chambres = context.select<RoomProvider, List<Chambre>>(
      (provider) => provider.chambres,
    );
    final chambresParId = {for (final c in chambres) c.id: c};
    final clientId = context.select<AuthProvider, int?>(
      (provider) => provider.utilisateurCourant?.clientId,
    );

    return Scaffold(
      appBar: PremiumAppBar(title: l10n.myReservationsTitle),
      body: FadeSlideIn(
        child: _enChargement
            ? const Center(child: CircularProgressIndicator())
            : clientId == null
            ? EmptyState(
                icone: Icons.link_off,
                message: l10n.accountNotLinkedToClient,
              )
            : (_reservations == null || _reservations!.isEmpty)
            ? EmptyState(
                icone: Icons.event_busy,
                message: l10n.noReservationsFound,
              )
            : RefreshIndicator(
                onRefresh: _charger,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  itemCount: _reservations!.length,
                  itemBuilder: (context, i) {
                    final reservation = _reservations![i];
                    final chambre = chambresParId[reservation.chambreId];
                    return Semantics(
                      label: l10n.reservationSemanticSummary(
                        l10n.unknownClient,
                        chambre?.numero ?? '-',
                        UiHelpers.formatDate(reservation.dateArrivee),
                        UiHelpers.formatDate(reservation.dateDepart),
                        reservation.dureeSejour.toString(),
                        UiHelpers.formatMontant(reservation.montantTotal),
                        reservation.statut.libelle,
                      ),
                      child: PremiumListTile(
                        icon: Icons.meeting_room_outlined,
                        title: l10n.roomNumberType(
                          chambre?.numero ?? '-',
                          chambre?.type.libelle ?? '',
                        ),
                        subtitle:
                            '${UiHelpers.formatDate(reservation.dateArrivee)} -> ${UiHelpers.formatDate(reservation.dateDepart)} - ${UiHelpers.formatMontant(reservation.montantTotal)}',
                        trailing: StatusBadge(
                          texte: reservation.statut.libelle,
                          couleur: UiHelpers.couleurStatutReservation(
                            reservation.statut,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
