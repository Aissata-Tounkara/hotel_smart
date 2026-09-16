import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/paiement.dart';
import '../../models/reservation.dart';
import '../../providers/client_provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../utils/ui_helpers.dart';
import '../../utils/validators.dart';

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
        const SnackBar(content: Text('Veuillez selectionner une reservation')),
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
        SnackBar(content: Text(paymentProvider.erreur ?? 'Erreur inconnue')),
      );
      paymentProvider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = context.watch<ReservationProvider>();
    final clientProvider = context.watch<ClientProvider>();
    final clientsParId = {for (final c in clientProvider.clients) c.id: c};

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau paiement')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<Reservation>(
              initialValue: _reservationSelectionnee,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Reservation', prefixIcon: Icon(Icons.event_note)),
              items: reservationProvider.reservations.map((r) {
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
                if (v != null) _montantController.text = v.montantTotal.toStringAsFixed(0);
              }),
              validator: (v) => v == null ? 'Veuillez selectionner une reservation' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _montantController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Montant (DA)', prefixIcon: Icon(Icons.payments_outlined)),
              validator: (v) => Validators.positiveNumber(v, champ: 'Le montant'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _methodeController,
              decoration: const InputDecoration(labelText: 'Methode de paiement', prefixIcon: Icon(Icons.credit_card)),
              validator: (v) => Validators.required(v, champ: 'La methode'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<StatutPaiement>(
              initialValue: _statut,
              decoration: const InputDecoration(labelText: 'Statut', prefixIcon: Icon(Icons.info_outline)),
              items: StatutPaiement.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.libelle)))
                  .toList(),
              onChanged: (v) => setState(() => _statut = v!),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _enEnregistrement ? null : _enregistrer,
                child: _enEnregistrement
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
