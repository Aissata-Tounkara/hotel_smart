import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chambre.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../utils/ui_helpers.dart';

/// Formulaire de nouvelle reservation : selection du client, des dates,
/// puis des chambres disponibles avec calcul automatique du montant
/// (points 21, 22, 23).
class ReservationFormScreen extends StatefulWidget {
  const ReservationFormScreen({super.key});

  @override
  State<ReservationFormScreen> createState() => _ReservationFormScreenState();
}

class _ReservationFormScreenState extends State<ReservationFormScreen> {
  Client? _clientSelectionne;
  DateTime? _dateArrivee;
  DateTime? _dateDepart;
  Chambre? _chambreSelectionnee;
  bool _enEnregistrement = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<ClientProvider>().charger());
  }

  Future<void> _choisirDate({required bool arrivee}) async {
    final maintenant = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: arrivee ? maintenant : (_dateArrivee ?? maintenant).add(const Duration(days: 1)),
      firstDate: arrivee ? maintenant : (_dateArrivee ?? maintenant),
      lastDate: maintenant.add(const Duration(days: 730)),
    );
    if (date == null || !mounted) return;
    setState(() {
      if (arrivee) {
        _dateArrivee = date;
        if (_dateDepart != null && !_dateDepart!.isAfter(date)) {
          _dateDepart = null;
        }
      } else {
        _dateDepart = date;
      }
      _chambreSelectionnee = null;
    });
    if (_dateArrivee != null && _dateDepart != null) {
      await context.read<ReservationProvider>().chercherChambresDisponibles(_dateArrivee!, _dateDepart!);
    }
  }

  Future<void> _confirmer() async {
    if (_clientSelectionne == null || _dateArrivee == null || _dateDepart == null || _chambreSelectionnee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez completer tous les champs')),
      );
      return;
    }
    setState(() => _enEnregistrement = true);
    final reservationProvider = context.read<ReservationProvider>();
    final succes = await reservationProvider.creerReservation(
      clientId: _clientSelectionne!.id!,
      chambre: _chambreSelectionnee!,
      arrivee: _dateArrivee!,
      depart: _dateDepart!,
    );
    if (!mounted) return;
    setState(() => _enEnregistrement = false);
    if (succes) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reservationProvider.erreur ?? 'Erreur inconnue')),
      );
      reservationProvider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = context.watch<ClientProvider>();
    final reservationProvider = context.watch<ReservationProvider>();
    final montant = (_chambreSelectionnee != null && _dateArrivee != null && _dateDepart != null)
        ? reservationProvider.calculerMontant(_chambreSelectionnee!, _dateArrivee!, _dateDepart!)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle reservation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<Client>(
            initialValue: _clientSelectionne,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Client', prefixIcon: Icon(Icons.person_outline)),
            items: clientProvider.clients
                .map((c) => DropdownMenuItem(value: c, child: Text(c.nomComplet, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (v) => setState(() => _clientSelectionne = v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(_dateArrivee == null ? 'Date arrivee' : UiHelpers.formatDate(_dateArrivee!)),
                  onPressed: () => _choisirDate(arrivee: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_dateDepart == null ? 'Date depart' : UiHelpers.formatDate(_dateDepart!)),
                  onPressed: _dateArrivee == null ? null : () => _choisirDate(arrivee: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_dateArrivee != null && _dateDepart != null) ...[
            Text('Chambres disponibles', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (reservationProvider.rechercheChambresEnCours)
              const Center(child: CircularProgressIndicator())
            else if (reservationProvider.chambresDisponibles.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Aucune chambre disponible pour ces dates'),
              )
            else
              RadioGroup<Chambre>(
                groupValue: _chambreSelectionnee,
                onChanged: (v) => setState(() => _chambreSelectionnee = v),
                child: Column(
                  children: reservationProvider.chambresDisponibles
                      .map((chambre) => RadioListTile<Chambre>(
                            value: chambre,
                            title: Text('Chambre ${chambre.numero} - ${chambre.type.libelle}'),
                            subtitle: Text('${UiHelpers.formatMontant(chambre.prixParNuit)} / nuit'),
                          ))
                      .toList(),
                ),
              ),
          ],
          if (montant != null) ...[
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Montant total', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(UiHelpers.formatMontant(montant), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _enEnregistrement ? null : _confirmer,
              child: _enEnregistrement
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Confirmer la reservation'),
            ),
          ),
        ],
      ),
    );
  }
}
