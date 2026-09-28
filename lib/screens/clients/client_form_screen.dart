import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    if (_nationaliteSelectionnee == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.selectNationality)));
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
      cin: _cinController.text.trim().isEmpty
          ? null
          : _cinController.text.trim(),
      dateCreation: widget.client?.dateCreation ?? DateTime.now(),
    );

    final succes = _estEdition
        ? await clientProvider.modifier(client)
        : await clientProvider.ajouter(client);

    if (!mounted) return;
    setState(() => _enEnregistrement = false);

    if (succes) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_messageErreurClient(clientProvider.erreur, l10n)),
        ),
      );
      clientProvider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final nationalites = context.select<ClientProvider, List<String>>(
      (provider) => provider.nationalites,
    );
    final chargementNationalites = context.select<ClientProvider, bool>(
      (provider) => provider.chargementNationalites,
    );
    final nationalitesDepuisSecours = context.select<ClientProvider, bool>(
      (provider) => provider.nationalitesDepuisSecours,
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PremiumAppBar(
        title: _estEdition ? l10n.editClient : l10n.newClient,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppTextField(
              controller: _prenomController,
              label: l10n.firstName,
              icon: Icons.person_outline,
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.requiredField(l10n.firstName)
                  : null,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _nomController,
              label: l10n.lastName,
              icon: Icons.badge_outlined,
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.requiredField(l10n.lastName)
                  : null,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _telephoneController,
              label: l10n.phone,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                final error = Validators.phone(value);
                if (error == null) return null;
                return error == 'Le telephone est obligatoire'
                    ? l10n.requiredField(l10n.phone)
                    : l10n.phoneInvalid;
              },
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _emailController,
              label: l10n.email,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final error = Validators.email(value);
                if (error == null) return null;
                return error == "L'email est obligatoire"
                    ? l10n.requiredField(l10n.email)
                    : l10n.emailInvalid;
              },
            ),
            const OrnamentalDivider(),
            AppTextField(
              controller: _cinController,
              label: l10n.cinPassportOptional,
              icon: Icons.credit_card_outlined,
            ),
            const SizedBox(height: 20),
            _buildNationaliteField(
              nationalites,
              chargementNationalites,
              nationalitesDepuisSecours,
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

  Widget _buildNationaliteField(
    List<String> nationalites,
    bool chargementNationalites,
    bool nationalitesDepuisSecours,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (chargementNationalites) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(l10n.loadingNationalities),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (nationalitesDepuisSecours)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.alerte.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppTheme.alerte.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.wifi_off, color: AppTheme.or, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.nationalitiesOffline,
                      style: AppTheme.manrope(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.read<ClientProvider>().chargerNationalites(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          ),
        DropdownButtonFormField<String>(
          initialValue: nationalites.contains(_nationaliteSelectionnee)
              ? _nationaliteSelectionnee
              : null,
          decoration: InputDecoration(
            labelText: l10n.nationality,
            prefixIcon: const Icon(Icons.public),
          ),
          isExpanded: true,
          items: nationalites
              .map(
                (n) => DropdownMenuItem(
                  value: n,
                  child: Text(n, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _nationaliteSelectionnee = v),
          validator: (v) => v == null ? l10n.selectNationality : null,
        ),
      ],
    );
  }
}

String _messageErreurClient(
  String? erreur,
  AppLocalizations l10n,
) => switch (erreur) {
  'Impossible de charger les clients' => l10n.clientLoadError,
  "Impossible d'ajouter le client" => l10n.clientSaveError,
  'Impossible de modifier le client' => l10n.clientUpdateError,
  'Impossible de supprimer le client : il possede peut-etre des reservations' =>
    l10n.clientDeleteError,
  _ => erreur ?? l10n.unknownError,
};
