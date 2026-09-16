import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chambre.dart';
import '../../providers/room_provider.dart';
import '../../utils/validators.dart';
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
        SnackBar(content: Text(roomProvider.erreur ?? 'Erreur inconnue')),
      );
      roomProvider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PremiumAppBar(title: _estEdition ? 'Modifier la chambre' : 'Nouvelle chambre'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppTextField(
              controller: _numeroController,
              label: 'Numero de chambre',
              icon: Icons.tag,
              validator: (v) => Validators.required(v, champ: 'Le numero'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<TypeChambre>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type de chambre', prefixIcon: Icon(Icons.category_outlined)),
              items: TypeChambre.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.libelle)))
                  .toList(),
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _prixController,
              label: 'Prix par nuit (DA)',
              icon: Icons.payments_outlined,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.positiveNumber(v, champ: 'Le prix'),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _etageController,
              label: 'Etage',
              icon: Icons.stairs_outlined,
              keyboardType: TextInputType.number,
              validator: (v) => Validators.positiveNumber(v, champ: 'L\'etage'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<StatutChambre>(
              initialValue: _statut,
              decoration: const InputDecoration(labelText: 'Statut', prefixIcon: Icon(Icons.info_outline)),
              items: StatutChambre.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.libelle)))
                  .toList(),
              onChanged: (v) => setState(() => _statut = v!),
            ),
            const OrnamentalDivider(),
            AppTextField(
              controller: _descriptionController,
              label: 'Description (optionnel)',
              maxLines: 3,
            ),
            const SizedBox(height: 28),
            GradientButton(
              label: 'ENREGISTRER',
              loading: _enEnregistrement,
              onPressed: _enregistrer,
            ),
          ],
        ),
      ),
    );
  }
}
