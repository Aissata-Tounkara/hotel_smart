import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
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
      appBar: AppBar(title: const Text('Clients')),
      floatingActionButton: authProvider.peutGererOperations
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ClientFormScreen()),
              ),
              child: const Icon(Icons.person_add_alt),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, telephone, email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
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
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: clients.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final client = clients[i];
                            return Card(
                              child: ListTile(
                                onTap: authProvider.peutGererOperations
                                    ? () => Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => ClientFormScreen(client: client)),
                                        )
                                    : null,
                                leading: CircleAvatar(
                                  child: Text(client.prenom.isNotEmpty ? client.prenom[0].toUpperCase() : '?'),
                                ),
                                title: Text(client.nomComplet),
                                subtitle: Text('${client.telephone} - ${client.nationalite}'),
                                trailing: authProvider.peutGererOperations
                                    ? IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        onPressed: () => _supprimer(context, client),
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
    );
  }
}
