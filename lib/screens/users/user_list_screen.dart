import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/utilisateur.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/premium_app_bar.dart';
import '../../widgets/premium_list_tile.dart';
import 'user_form_screen.dart';

/// Gestion des comptes utilisateurs (CRUD complet), reservee a l'Admin
/// (point 16).
class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<UserProvider>().charger());
  }

  Future<void> _supprimer(BuildContext context, Utilisateur utilisateur) async {
    final authProvider = context.read<AuthProvider>();
    if (utilisateur.id == authProvider.utilisateurCourant?.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous ne pouvez pas supprimer votre propre compte')),
      );
      return;
    }
    final confirme = await afficherConfirmation(
      context,
      titre: 'Supprimer l\'utilisateur',
      message: 'Supprimer le compte de ${utilisateur.nom} ?',
      destructif: true,
    );
    if (!confirme || !context.mounted) return;
    await context.read<UserProvider>().supprimer(utilisateur.id!);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final utilisateurs = userProvider.utilisateurs;

    return Scaffold(
      appBar: const PremiumAppBar(title: 'Utilisateurs'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const UserFormScreen()),
        ),
        child: const Icon(Icons.person_add),
      ),
      body: FadeSlideIn(
        child: userProvider.enChargement
            ? const Center(child: CircularProgressIndicator())
            : utilisateurs.isEmpty
                ? const EmptyState(icone: Icons.people_alt_outlined, message: 'Aucun utilisateur')
                : RefreshIndicator(
                    onRefresh: userProvider.charger,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: utilisateurs.length,
                      itemBuilder: (context, i) {
                        final utilisateur = utilisateurs[i];
                        return PremiumListTile(
                          icon: Icons.person_outline,
                          title: utilisateur.nom,
                          subtitle: '${utilisateur.email} - ${utilisateur.role.libelle}',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => UserFormScreen(utilisateur: utilisateur)),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Theme.of(context).colorScheme.error,
                            onPressed: () => _supprimer(context, utilisateur),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
