import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/client.dart';
import '../../models/utilisateur.dart';
import '../../providers/client_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/ornamental_divider.dart';
import '../../widgets/premium_app_bar.dart';

/// Formulaire de creation/edition d'un compte utilisateur (reserve a
/// l'Admin). Permet de lier manuellement un compte de role Client a une
/// fiche client existante (point 16).
class UserFormScreen extends StatefulWidget {
  final Utilisateur? utilisateur;
  const UserFormScreen({super.key, this.utilisateur});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _emailController;
  late final TextEditingController _motDePasseController;
  late final TextEditingController _confirmationController;
  late RoleUtilisateur _role;
  Client? _clientLie;
  bool _enEnregistrement = false;

  bool get _estEdition => widget.utilisateur != null;

  @override
  void initState() {
    super.initState();
    final u = widget.utilisateur;
    _nomController = TextEditingController(text: u?.nom ?? '');
    _emailController = TextEditingController(text: u?.email ?? '');
    _motDePasseController = TextEditingController();
    _confirmationController = TextEditingController();
    _role = u?.role ?? RoleUtilisateur.receptionniste;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final clientProvider = context.read<ClientProvider>();
      await clientProvider.charger();
      if (u?.clientId != null && mounted) {
        final correspondances = clientProvider.clients.where(
          (c) => c.id == u!.clientId,
        );
        setState(() {
          _clientLie = correspondances.isEmpty ? null : correspondances.first;
        });
      }
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _motDePasseController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _enEnregistrement = true);

    final userProvider = context.read<UserProvider>();
    final clientId = _role == RoleUtilisateur.client ? _clientLie?.id : null;

    final succes = _estEdition
        ? await userProvider.modifier(
            utilisateur: widget.utilisateur!,
            nom: _nomController.text,
            email: _emailController.text,
            nouveauMotDePasse: _motDePasseController.text.isEmpty
                ? null
                : _motDePasseController.text,
            role: _role,
            clientId: clientId,
          )
        : await userProvider.creer(
            nom: _nomController.text,
            email: _emailController.text,
            motDePasse: _motDePasseController.text,
            role: _role,
            clientId: clientId,
          );

    if (!mounted) return;
    setState(() => _enEnregistrement = false);

    if (succes) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            userProvider.erreur ?? AppLocalizations.of(context)!.unknownError,
          ),
        ),
      );
      userProvider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clients = context.select<ClientProvider, List<Client>>(
      (provider) => provider.clients,
    );
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PremiumAppBar(title: _estEdition ? l10n.editUser : l10n.newUser),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppTextField(
              controller: _nomController,
              label: l10n.fullName,
              icon: Icons.person_outline,
              validator: (v) => Validators.required(v, champ: l10n.name),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _emailController,
              label: l10n.email,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const OrnamentalDivider(),
            AppTextField(
              controller: _motDePasseController,
              label: _estEdition
                  ? l10n.profileNewPasswordOptional
                  : l10n.password,
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (v) {
                if (_estEdition && (v == null || v.isEmpty)) return null;
                return Validators.password(v);
              },
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _confirmationController,
              label: l10n.confirmPassword,
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (v) {
                if (_motDePasseController.text.isEmpty) return null;
                return Validators.confirmPassword(
                  v,
                  _motDePasseController.text,
                );
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<RoleUtilisateur>(
              initialValue: _role,
              decoration: InputDecoration(
                labelText: l10n.role,
                prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
              ),
              items: RoleUtilisateur.values
                  .map(
                    (r) => DropdownMenuItem(value: r, child: Text(r.libelle)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _role = v!),
            ),
            if (_role == RoleUtilisateur.client) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<Client>(
                initialValue: _clientLie,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: l10n.clientRecordToLink,
                  prefixIcon: const Icon(Icons.link),
                  helperText: l10n.clientLinkHelp,
                ),
                items: clients
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                          c.nomComplet,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _clientLie = v),
                validator: (v) => v == null ? l10n.selectClientRecord : null,
              ),
            ],
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
