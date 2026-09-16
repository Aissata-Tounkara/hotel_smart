import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/paiement.dart';
import '../../providers/client_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/premium_app_bar.dart';
import '../../widgets/premium_list_tile.dart';
import '../../widgets/status_badge.dart';
import 'payment_form_screen.dart';

/// Liste des paiements avec suivi du statut (Paye / En attente / Rembourse)
/// et possibilite de changer le statut (point 33).
class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().charger();
      context.read<ReservationProvider>().charger();
      context.read<ClientProvider>().charger();
    });
  }

  Future<void> _changerStatut(Paiement paiement) async {
    final nouveauStatut = await showModalBottomSheet<StatutPaiement>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: StatutPaiement.values
              .map((s) => ListTile(
                    title: Text(s.libelle),
                    trailing: s == paiement.statut ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.of(context).pop(s),
                  ))
              .toList(),
        ),
      ),
    );
    if (nouveauStatut == null || !mounted) return;
    await context.read<PaymentProvider>().changerStatut(paiement, nouveauStatut);
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentProvider>();
    final reservationProvider = context.watch<ReservationProvider>();
    final clientProvider = context.watch<ClientProvider>();

    final reservationsParId = {for (final r in reservationProvider.reservations) r.id: r};
    final clientsParId = {for (final c in clientProvider.clients) c.id: c};

    final paiements = paymentProvider.paiements;

    return Scaffold(
      appBar: const PremiumAppBar(title: 'Paiements'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PaymentFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: FadeSlideIn(
        child: paymentProvider.enChargement
            ? const Center(child: CircularProgressIndicator())
            : paiements.isEmpty
                ? const EmptyState(icone: Icons.receipt_long_outlined, message: 'Aucun paiement enregistre')
                : RefreshIndicator(
                    onRefresh: paymentProvider.charger,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: paiements.length,
                      itemBuilder: (context, i) {
                        final paiement = paiements[i];
                        final reservation = reservationsParId[paiement.reservationId];
                        final client = reservation != null ? clientsParId[reservation.clientId] : null;
                        return PremiumListTile(
                          icon: Icons.receipt_long_outlined,
                          title: client?.nomComplet ?? 'Reservation #${paiement.reservationId}',
                          subtitle: '${paiement.methode} - ${UiHelpers.formatDate(paiement.datePaiement)}',
                          onTap: () => _changerStatut(paiement),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                UiHelpers.formatMontant(paiement.montant),
                                style: AppTheme.manrope(fontWeight: FontWeight.w700, color: Theme.of(context).textTheme.bodyLarge?.color),
                              ),
                              const SizedBox(height: 4),
                              StatusBadge(texte: paiement.statut.libelle, couleur: UiHelpers.couleurStatutPaiement(paiement.statut)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
