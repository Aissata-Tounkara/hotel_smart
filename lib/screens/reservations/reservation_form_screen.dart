import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/chambre.dart';
import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../../providers/reservation_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';

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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ClientProvider>().charger(),
    );
  }

  Future<void> _choisirDate({required bool arrivee}) async {
    final maintenant = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: arrivee
          ? maintenant
          : (_dateArrivee ?? maintenant).add(const Duration(days: 1)),
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
      await context.read<ReservationProvider>().chercherChambresDisponibles(
        _dateArrivee!,
        _dateDepart!,
      );
    }
  }

  Future<void> _confirmer() async {
    if (_clientSelectionne == null ||
        _dateArrivee == null ||
        _dateDepart == null ||
        _chambreSelectionnee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.completeAllFields),
        ),
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
        SnackBar(
          content: Text(
            reservationProvider.erreur ??
                AppLocalizations.of(context)!.unknownError,
          ),
        ),
      );
      reservationProvider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = context.read<ReservationProvider>();
    final clients = context.select<ClientProvider, List<Client>>(
      (provider) => provider.clients,
    );
    final rechercheChambresEnCours = context.select<ReservationProvider, bool>(
      (provider) => provider.rechercheChambresEnCours,
    );
    final chambresDisponibles = context
        .select<ReservationProvider, List<Chambre>>(
          (provider) => provider.chambresDisponibles,
        );
    final or = Theme.of(context).colorScheme.secondary;
    final l10n = AppLocalizations.of(context)!;
    final montant =
        (_chambreSelectionnee != null &&
            _dateArrivee != null &&
            _dateDepart != null)
        ? reservationProvider.calculerMontant(
            _chambreSelectionnee!,
            _dateArrivee!,
            _dateDepart!,
          )
        : null;

    return Scaffold(
      appBar: PremiumAppBar(title: l10n.newReservation),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<Client>(
            initialValue: _clientSelectionne,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.clients,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            items: clients
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.nomComplet, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _clientSelectionne = v),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today_outlined, size: 18),
                  label: Text(
                    _dateArrivee == null
                        ? l10n.arrivalDate
                        : UiHelpers.formatDate(_dateArrivee!),
                  ),
                  onPressed: () => _choisirDate(arrivee: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    _dateDepart == null
                        ? l10n.departureDate
                        : UiHelpers.formatDate(_dateDepart!),
                  ),
                  onPressed: _dateArrivee == null
                      ? null
                      : () => _choisirDate(arrivee: false),
                ),
              ),
            ],
          ),
          if (_dateArrivee != null && _dateDepart != null) ...[
            const OrnamentalDivider(),
            Text(
              l10n.availableRoomsLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (rechercheChambresEnCours)
              const Center(child: CircularProgressIndicator())
            else if (chambresDisponibles.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  l10n.noRoomsAvailableDates,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else
              RadioGroup<Chambre>(
                groupValue: _chambreSelectionnee,
                onChanged: (v) => setState(() => _chambreSelectionnee = v),
                child: Column(
                  children: chambresDisponibles
                      .map(
                        (chambre) => RadioListTile<Chambre>(
                          value: chambre,
                          activeColor: or,
                          title: Text(
                            l10n.roomNumberType(
                              chambre.numero,
                              chambre.type.libelle,
                            ),
                          ),
                          subtitle: Text(
                            l10n.roomPricePerNight(
                              UiHelpers.formatMontant(chambre.prixParNuit),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
          if (montant != null) ...[
            const OrnamentalDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.totalAmount,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  UiHelpers.formatMontant(montant),
                  style: AppTheme.playfair(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 28),
          GradientButton(
            label: l10n.reservationConfirmAction,
            loading: _enEnregistrement,
            onPressed: _confirmer,
          ),
        ],
      ),
    );
  }
}
