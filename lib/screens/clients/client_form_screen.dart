import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../models/client.dart';
import '../../providers/client_provider.dart';
import '../../utils/validators.dart';

/// Formulaire de creation/edition d'un client, avec liste des nationalites
/// peuplee depuis l'API restcountries.com (points 26, 27, 28).
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
      appBar: AppBar(title: Text(_estEdition ? 'Modifier le client' : 'Nouveau client')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prenom', prefixIcon: Icon(Icons.person_outline)),
              validator: (v) => Validators.required(v, champ: 'Le prenom'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom', prefixIcon: Icon(Icons.badge_outlined)),
              validator: (v) => Validators.required(v, champ: 'Le nom'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telephoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telephone', prefixIcon: Icon(Icons.phone_outlined)),
              validator: Validators.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cinController,
              decoration: const InputDecoration(labelText: 'CIN / Passeport (optionnel)', prefixIcon: Icon(Icons.credit_card_outlined)),
            ),
            const SizedBox(height: 16),
            _buildNationaliteField(clientProvider),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _enEnregistrement ? null : _enregistrer,
                child: _enEnregistrement
                    ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                    : const Text('Enregistrer'),
              ),
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

    if (clientProvider.erreurNationalites != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(clientProvider.erreurNationalites!, style: const TextStyle(color: Colors.red))),
            TextButton(
              onPressed: () => context.read<ClientProvider>().chargerNationalites(),
              child: const Text('Reessayer'),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<String>(
      initialValue: clientProvider.nationalites.contains(_nationaliteSelectionnee) ? _nationaliteSelectionnee : null,
      decoration: const InputDecoration(labelText: 'Nationalite', prefixIcon: Icon(Icons.public)),
      isExpanded: true,
      items: clientProvider.nationalites
          .map((n) => DropdownMenuItem(value: n, child: Text(n, overflow: TextOverflow.ellipsis)))
          .toList(),
      onChanged: (v) => setState(() => _nationaliteSelectionnee = v),
      validator: (v) => v == null ? 'Veuillez selectionner une nationalite' : null,
    );
  }
}
