import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<ClientProvider>().charger());
  }

  Future<void> _supprimer(BuildContext context, Client client) async {
    final confirme = await afficherConfirmation(
      context,
      titre: 'Supprimer le client',
      message: 'Supprimer ${client.nomComplet} ? Cette action est irreversible.',
      destructif: true,
    );
    if (!confirme || !context.mounted) return;
    final succes = await context.read<ClientProvider>().supprimer(client.id!);
    if (!succes && context.mounted) {
      final provider = context.read<ClientProvider>();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.erreur ?? 'Erreur')));
      provider.effacerErreur();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = context.watch<ClientProvider>();
    final authProvider = context.watch<AuthProvider>();
    final clients = clientProvider.clients;

    return Scaffold(
      appBar: const PremiumAppBar(title: 'Clients'),
      floatingActionButton: authProvider.peutGererOperations
          ? FloatingActionButton(
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
                label: 'Rechercher par nom, telephone, email',
                icon: Icons.search,
                onChanged: clientProvider.rechercher,
              ),
            ),
            Expanded(
              child: clientProvider.enChargement
                  ? const Center(child: CircularProgressIndicator())
                  : clients.isEmpty
                      ? const EmptyState(icone: Icons.people_outline, message: 'Aucun client trouve')
                      : RefreshIndicator(
                          onRefresh: clientProvider.charger,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            itemCount: clients.length,
                            itemBuilder: (context, i) {
                              final client = clients[i];
                              return PremiumListTile(
                                icon: Icons.person_outline,
                                title: client.nomComplet,
                                subtitle: '${client.telephone} - ${client.nationalite}',
                                onTap: authProvider.peutGererOperations
                                    ? () => Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => ClientFormScreen(client: client)),
                                        )
                                    : null,
                                trailing: authProvider.peutGererOperations
                                    ? IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        color: Theme.of(context).colorScheme.error,
                                        onPressed: () => _supprimer(context, client),
                                      )
                                    : null,
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
