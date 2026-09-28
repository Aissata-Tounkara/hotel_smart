import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/chambre.dart';
import '../../providers/room_provider.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';

/// Formulaire de creation/edition d'une chambre (points 17, 18).
class RoomFormScreen extends StatefulWidget {
  final Chambre? chambre;
  const RoomFormScreen({super.key, this.chambre});

  @override
  State<RoomFormScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends State<RoomFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numeroController;
  late final TextEditingController _prixController;
  late final TextEditingController _etageController;
  late final TextEditingController _descriptionController;
  late TypeChambre _type;
  late StatutChambre _statut;
  bool _enEnregistrement = false;

  bool get _estEdition => widget.chambre != null;

  @override
  void initState() {
    super.initState();
    final c = widget.chambre;
    _numeroController = TextEditingController(text: c?.numero ?? '');
    _prixController = TextEditingController(text: c != null ? c.prixParNuit.toStringAsFixed(0) : '');
    _etageController = TextEditingController(text: c != null ? c.etage.toString() : '');
    _descriptionController = TextEditingController(text: c?.description ?? '');
    _type = c?.type ?? TypeChambre.simple;
    _statut = c?.statut ?? StatutChambre.disponible;
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _prixController.dispose();
    _etageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _enEnregistrement = true);

    final roomProvider = context.read<RoomProvider>();
    final chambre = Chambre(
      id: widget.chambre?.id,
      numero: _numeroController.text.trim(),
      type: _type,
      prixParNuit: double.parse(_prixController.text.trim()),
      statut: _statut,
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      etage: int.parse(_etageController.text.trim()),
    );

    final succes = _estEdition
        ? await roomProvider.modifier(chambre)
        : await roomProvider.ajouter(chambre);

    if (!mounted) return;
    setState(() => _enEnregistrement = false);

    if (succes) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_messageErreurRoom(roomProvider.erreur, l10n))),
      );
      roomProvider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: PremiumAppBar(title: _estEdition ? l10n.editRoom : l10n.newRoom),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppTextField(
              controller: _numeroController,
              label: l10n.roomNumberField,
              icon: Icons.tag,
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.requiredField(l10n.roomNumberField)
                  : null,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<TypeChambre>(
              initialValue: _type,
              decoration: InputDecoration(
                labelText: l10n.roomTypeField,
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: TypeChambre.values
                  .map((t) => DropdownMenuItem(
                    value: t,
                    child: Text(_libelleTypeChambre(t, l10n)),
                  ))
                  .toList(),
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _prixController,
              label: l10n.roomPriceField,
              icon: Icons.payments_outlined,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => _validerNombrePositif(
                v,
                l10n,
                l10n.roomPriceField,
              ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _etageController,
              label: l10n.roomFloorField,
              icon: Icons.stairs_outlined,
              keyboardType: TextInputType.number,
              validator: (v) => _validerNombrePositif(
                v,
                l10n,
                l10n.roomFloorField,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<StatutChambre>(
              initialValue: _statut,
              decoration: InputDecoration(
                labelText: l10n.roomStatusField,
                prefixIcon: const Icon(Icons.info_outline),
              ),
              items: StatutChambre.values
                  .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(_libelleStatutChambre(s, l10n)),
                  ))
                  .toList(),
              onChanged: (v) => setState(() => _statut = v!),
            ),
            const OrnamentalDivider(),
            AppTextField(
              controller: _descriptionController,
              label: l10n.roomDescriptionOptional,
              maxLines: 3,
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

String? _validerNombrePositif(
  String? value,
  AppLocalizations l10n,
  String field,
) {
  if (value == null || value.trim().isEmpty) {
    return l10n.requiredField(field);
  }
  final number = num.tryParse(value.trim());
  if (number == null || number <= 0) {
    return l10n.positiveNumberField(field);
  }
  return null;
}

String _libelleTypeChambre(TypeChambre type, AppLocalizations l10n) =>
    switch (type) {
      TypeChambre.simple => l10n.roomTypeSingle,
      TypeChambre.double_ => l10n.roomTypeDouble,
      TypeChambre.suite => l10n.roomTypeSuite,
    };

String _libelleStatutChambre(StatutChambre statut, AppLocalizations l10n) =>
    switch (statut) {
      StatutChambre.disponible => l10n.roomStatusAvailable,
      StatutChambre.occupee => l10n.roomStatusOccupied,
      StatutChambre.maintenance => l10n.roomStatusMaintenance,
    };

String _messageErreurRoom(String? erreur, AppLocalizations l10n) =>
    switch (erreur) {
      'Une chambre avec ce numero existe deja' => l10n.duplicateRoomNumber,
      "Impossible d'ajouter la chambre" => l10n.roomSaveError,
      'Impossible de modifier la chambre' => l10n.roomUpdateError,
      'Impossible de supprimer la chambre' => l10n.roomDeleteError,
      _ => erreur ?? l10n.unknownError,
    };
