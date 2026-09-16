import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';

/// Formulaire de creation/edition d'un client, avec liste des nationalites
/// peuplee depuis l'API countries.dev (points 26, 27, 28).
class ClientFormScreen extends StatefulWidget {
  final Client? client;
  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _telephoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _cinController;
  String? _nationaliteSelectionnee;
  bool _enEnregistrement = false;

  bool get _estEdition => widget.client != null;

  @override
  void initState() {
    super.initState();
    final c = widget.client;
    _nomController = TextEditingController(text: c?.nom ?? '');
    _prenomController = TextEditingController(text: c?.prenom ?? '');
    _telephoneController = TextEditingController(text: c?.telephone ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _cinController = TextEditingController(text: c?.cin ?? '');
    _nationaliteSelectionnee = c?.nationalite;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clientProvider = context.read<ClientProvider>();
      if (clientProvider.nationalites.isEmpty) {
        clientProvider.chargerNationalites();
      }
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _cinController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    if (_nationaliteSelectionnee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez selectionner une nationalite')),
      );
      return;
    }
    setState(() => _enEnregistrement = true);

    final clientProvider = context.read<ClientProvider>();
    final client = Client(
      id: widget.client?.id,
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      telephone: _telephoneController.text.trim(),
      email: _emailController.text.trim(),
      nationalite: _nationaliteSelectionnee!,
      cin: _cinController.text.trim().isEmpty ? null : _cinController.text.trim(),
      dateCreation: widget.client?.dateCreation ?? DateTime.now(),
    );

    final succes = _estEdition ? await clientProvider.modifier(client) : await clientProvider.ajouter(client);

    if (!mounted) return;
    setState(() => _enEnregistrement = false);

    if (succes) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(clientProvider.erreur ?? 'Erreur inconnue')),
      );
      clientProvider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = context.watch<ClientProvider>();

    return Scaffold(
      appBar: PremiumAppBar(title: _estEdition ? 'Modifier le client' : 'Nouveau client'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppTextField(
              controller: _prenomController,
              label: 'Prenom',
              icon: Icons.person_outline,
              validator: (v) => Validators.required(v, champ: 'Le prenom'),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _nomController,
              label: 'Nom',
              icon: Icons.badge_outlined,
              validator: (v) => Validators.required(v, champ: 'Le nom'),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _telephoneController,
              label: 'Telephone',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const OrnamentalDivider(),
            AppTextField(
              controller: _cinController,
              label: 'CIN / Passeport (optionnel)',
              icon: Icons.credit_card_outlined,
            ),
            const SizedBox(height: 20),
            _buildNationaliteField(clientProvider),
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

  Widget _buildNationaliteField(ClientProvider clientProvider) {
    if (clientProvider.chargementNationalites) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 12),
            Text('Chargement des nationalites...'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (clientProvider.nationalitesDepuisSecours)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.alerte.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.alerte.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.wifi_off, color: AppTheme.or, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Liste hors-ligne (service indisponible) : options limitees',
                      style: AppTheme.manrope(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.read<ClientProvider>().chargerNationalites(),
                    child: const Text('Reessayer'),
                  ),
                ],
              ),
            ),
          ),
        DropdownButtonFormField<String>(
          initialValue: clientProvider.nationalites.contains(_nationaliteSelectionnee) ? _nationaliteSelectionnee : null,
          decoration: const InputDecoration(labelText: 'Nationalite', prefixIcon: Icon(Icons.public)),
          isExpanded: true,
          items: clientProvider.nationalites
              .map((n) => DropdownMenuItem(value: n, child: Text(n, overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: (v) => setState(() => _nationaliteSelectionnee = v),
          validator: (v) => v == null ? 'Veuillez selectionner une nationalite' : null,
        ),
      ],
    );
  }
}
