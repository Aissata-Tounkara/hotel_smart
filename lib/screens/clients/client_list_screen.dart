import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/client.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/premium_app_bar.dart';
import '../../widgets/premium_list_tile.dart';
import 'client_form_screen.dart';

/// Liste des clients avec recherche temps reel et CRUD complet (point 26).
class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ClientProvider>().charger(),
    );
  }

  Future<void> _supprimer(BuildContext context, Client client) async {
    final l10n = AppLocalizations.of(context)!;
    final confirme = await afficherConfirmation(
      context,
      titre: l10n.deleteClientTitle,
      message: l10n.deleteClientConfirmation(client.nomComplet),
      texteConfirmer: l10n.delete,
      texteAnnuler: l10n.cancel,
      destructif: true,
    );
    if (!confirme || !context.mounted) return;
    final succes = await context.read<ClientProvider>().supprimer(client.id!);
    if (!succes && context.mounted) {
      final provider = context.read<ClientProvider>();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(_messageErreurClient(provider.erreur, l10n))),
      );
      provider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = context.watch<ClientProvider>();
    final authProvider = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;
    final clients = clientProvider.clients;

    return Scaffold(
      appBar: PremiumAppBar(title: l10n.clients),
      floatingActionButton: authProvider.peutGererOperations
          ? FloatingActionButton(
              tooltip: l10n.addClient,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ClientFormScreen()),
              ),
              child: const Icon(Icons.person_add_alt),
            )
          : null,
      body: FadeSlideIn(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: AppTextField(
                label: l10n.clientSearch,
                icon: Icons.search,
                onChanged: clientProvider.rechercher,
              ),
            ),
            Expanded(
              child: clientProvider.enChargement
                  ? const Center(child: CircularProgressIndicator())
                  : clients.isEmpty
                  ? EmptyState(
                      icone: Icons.people_outline,
                      message: l10n.noClientsFound,
                    )
                  : RefreshIndicator(
                      onRefresh: clientProvider.charger,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: clients.length,
                        itemBuilder: (context, i) {
                          final client = clients[i];
                          return Semantics(
                            label: l10n.clientSemanticSummary(
                              client.nomComplet,
                              client.telephone,
                              client.nationalite,
                            ),
                            child: PremiumListTile(
                              icon: Icons.person_outline,
                              title: client.nomComplet,
                              subtitle: l10n.clientSubtitle(
                                client.telephone,
                                client.nationalite,
                              ),
                              onTap: authProvider.peutGererOperations
                                  ? () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ClientFormScreen(client: client),
                                      ),
                                    )
                                  : null,
                              trailing: authProvider.peutGererOperations
                                  ? IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      tooltip: l10n.deleteClientTooltip(
                                        client.nomComplet,
                                      ),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      onPressed: () =>
                                          _supprimer(context, client),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

String _messageErreurClient(String? erreur, AppLocalizations l10n) =>
    switch (erreur) {
      'Impossible de charger les clients' => l10n.clientLoadError,
      "Impossible d'ajouter le client" => l10n.clientSaveError,
      'Impossible de modifier le client' => l10n.clientUpdateError,
      'Impossible de supprimer le client : il possede peut-etre des reservations' =>
        l10n.clientDeleteError,
      _ => erreur ?? l10n.unknownError,
    };
