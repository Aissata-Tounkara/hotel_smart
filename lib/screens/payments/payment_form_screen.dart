import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/paiement.dart';
import '../../models/client.dart';
import '../../models/reservation.dart';
import '../../providers/client_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../utils/ui_helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';

/// Formulaire d'enregistrement d'un paiement pour une reservation
/// (point 33).
class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  final _methodeController = TextEditingController(text: 'Especes');
  Reservation? _reservationSelectionnee;
  StatutPaiement _statut = StatutPaiement.paye;
  bool _enEnregistrement = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReservationProvider>().charger();
      context.read<ClientProvider>().charger();
    });
  }

  @override
  void dispose() {
    _montantController.dispose();
    _methodeController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_reservationSelectionnee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectReservation),
        ),
      );
      return;
    }
    setState(() => _enEnregistrement = true);
    final paymentProvider = context.read<PaymentProvider>();
    final paiement = Paiement(
      reservationId: _reservationSelectionnee!.id!,
      montant: double.parse(_montantController.text.trim()),
      statut: _statut,
      methode: _methodeController.text.trim(),
      datePaiement: DateTime.now(),
    );
    final succes = await paymentProvider.enregistrer(paiement);
    if (!mounted) return;
    setState(() => _enEnregistrement = false);
    if (succes) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            paymentProvider.erreur ??
                AppLocalizations.of(context)!.unknownError,
          ),
        ),
      );
      paymentProvider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reservations = context.select<ReservationProvider, List<Reservation>>(
      (provider) => provider.reservations,
    );
    final clients = context.select<ClientProvider, List<Client>>(
      (provider) => provider.clients,
    );
    final clientsParId = {for (final c in clients) c.id: c};

    return Scaffold(
      appBar: PremiumAppBar(title: l10n.newPayment),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<Reservation>(
              initialValue: _reservationSelectionnee,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: l10n.reservation,
                prefixIcon: const Icon(Icons.event_note),
              ),
              items: reservations.map((r) {
                final client = clientsParId[r.clientId];
                return DropdownMenuItem(
                  value: r,
                  child: Text(
                    '${client?.nomComplet ?? 'Client #${r.clientId}'} - ${UiHelpers.formatMontant(r.montantTotal)}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() {
                _reservationSelectionnee = v;
                if (v != null) {
                  _montantController.text = v.montantTotal.toStringAsFixed(0);
                }
              }),
              validator: (v) => v == null ? l10n.selectReservation : null,
            ),
            const OrnamentalDivider(),
            AppTextField(
              controller: _montantController,
              label: l10n.paymentAmount,
              icon: Icons.payments_outlined,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) =>
                  Validators.positiveNumber(v, champ: l10n.totalAmount),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _methodeController,
              label: l10n.paymentMethod,
              icon: Icons.credit_card,
              validator: (v) =>
                  Validators.required(v, champ: l10n.paymentMethod),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<StatutPaiement>(
              initialValue: _statut,
              decoration: InputDecoration(
                labelText: l10n.paymentStatus,
                prefixIcon: const Icon(Icons.info_outline),
              ),
              items: StatutPaiement.values
                  .map(
                    (s) => DropdownMenuItem(value: s, child: Text(s.libelle)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _statut = v!),
            ),
            const SizedBox(height: 28),
            GradientButton(
              label: l10n.save.toUpperCase(),
              loading: _enEnregistrement,
              onPressed: _enregistrer,
            ),
          ],
        ),
      ),
    );
  }
}
