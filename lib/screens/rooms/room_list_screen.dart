import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chambre.dart';
import '../../providers/auth_provider.dart';
import '../../providers/room_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/ui_helpers.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/fade_slide_in.dart';
import '../../widgets/premium_app_bar.dart';
import '../../widgets/premium_list_tile.dart';
import '../../widgets/status_badge.dart';
import 'room_form_screen.dart';

/// Liste des chambres avec recherche temps reel, filtres (type, statut,
/// prix) et bascule vue Liste / Carte (points 17, 19, 20).
class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  bool _vueCarte = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<RoomProvider>().charger());
  }

  Future<void> _supprimer(BuildContext context, Chambre chambre) async {
    final confirme = await afficherConfirmation(
      context,
      titre: 'Supprimer la chambre',
      message: 'Supprimer la chambre ${chambre.numero} ? Cette action est irreversible.',
      destructif: true,
    );
    if (!confirme || !context.mounted) return;
    await context.read<RoomProvider>().supprimer(chambre.id!);
  }

  void _ouvrirFiltres(BuildContext context) {
    final roomProvider = context.read<RoomProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FiltresChambresSheet(roomProvider: roomProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = context.watch<RoomProvider>();
    final authProvider = context.watch<AuthProvider>();
    final chambres = roomProvider.chambres;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Chambres',
        actions: [
          IconButton(
            icon: Icon(_vueCarte ? Icons.view_list : Icons.grid_view),
            tooltip: _vueCarte ? 'Vue liste' : 'Vue carte',
            onPressed: () => setState(() => _vueCarte = !_vueCarte),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Filtres',
            onPressed: () => _ouvrirFiltres(context),
          ),
        ],
      ),
      floatingActionButton: authProvider.peutGererOperations
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RoomFormScreen()),
              ),
              child: const Icon(Icons.add),
            )
          : null,
      body: FadeSlideIn(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: AppTextField(
                label: 'Rechercher par numero ou type',
                icon: Icons.search,
                onChanged: roomProvider.rechercher,
              ),
            ),
            Expanded(
              child: roomProvider.enChargement
                  ? const Center(child: CircularProgressIndicator())
                  : chambres.isEmpty
                      ? const EmptyState(icone: Icons.bed_outlined, message: 'Aucune chambre trouvee')
                      : RefreshIndicator(
                          onRefresh: roomProvider.charger,
                          child: _vueCarte
                              ? GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.95,
                                  ),
                                  itemCount: chambres.length,
                                  itemBuilder: (context, i) => _CarteChambre(
                                    chambre: chambres[i],
                                    peutModifier: authProvider.peutGererOperations,
                                    onModifier: () => Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => RoomFormScreen(chambre: chambres[i])),
                                    ),
                                    onSupprimer: () => _supprimer(context, chambres[i]),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  itemCount: chambres.length,
                                  itemBuilder: (context, i) {
                                    final chambre = chambres[i];
                                    return PremiumListTile(
                                      icon: Icons.meeting_room_outlined,
                                      title: 'Chambre ${chambre.numero} - ${chambre.type.libelle}',
                                      subtitle: '${UiHelpers.formatMontant(chambre.prixParNuit)} / nuit - Etage ${chambre.etage}',
                                      onTap: authProvider.peutGererOperations
                                          ? () => Navigator.of(context).push(
                                                MaterialPageRoute(builder: (_) => RoomFormScreen(chambre: chambre)),
                                              )
                                          : null,
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          StatusBadge(texte: chambre.statut.libelle, couleur: UiHelpers.couleurStatutChambre(chambre.statut)),
                                          if (authProvider.peutGererOperations)
                                            PopupMenuButton<String>(
                                              onSelected: (v) => v == 'modifier'
                                                  ? Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (_) => RoomFormScreen(chambre: chambre)),
                                                    )
                                                  : _supprimer(context, chambre),
                                              itemBuilder: (context) => const [
                                                PopupMenuItem(value: 'modifier', child: Text('Modifier')),
                                                PopupMenuItem(value: 'supprimer', child: Text('Supprimer')),
                                              ],
                                            ),
                                        ],
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

class _CarteChambre extends StatelessWidget {
  final Chambre chambre;
  final bool peutModifier;
  final VoidCallback onModifier;
  final VoidCallback onSupprimer;

  const _CarteChambre({
    required this.chambre,
    required this.peutModifier,
    required this.onModifier,
    required this.onSupprimer,
  });

  @override
  Widget build(BuildContext context) {
    final or = Theme.of(context).colorScheme.secondary;
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: peutModifier ? onModifier : null,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: or.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.meeting_room_outlined, color: or),
                if (peutModifier)
                  PopupMenuButton<String>(
                    onSelected: (v) => v == 'modifier' ? onModifier() : onSupprimer(),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'modifier', child: Text('Modifier')),
                      PopupMenuItem(value: 'supprimer', child: Text('Supprimer')),
                    ],
                  ),
              ],
            ),
            const Spacer(),
            Text('Chambre ${chambre.numero}', style: AppTheme.playfair(fontSize: 17)),
            Text(chambre.type.libelle, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(
              UiHelpers.formatMontant(chambre.prixParNuit),
              style: AppTheme.manrope(fontWeight: FontWeight.w700, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            const SizedBox(height: 8),
            StatusBadge(
              texte: chambre.statut.libelle,
              couleur: UiHelpers.couleurStatutChambre(chambre.statut),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltresChambresSheet extends StatefulWidget {
  final RoomProvider roomProvider;
  const _FiltresChambresSheet({required this.roomProvider});

  @override
  State<_FiltresChambresSheet> createState() => _FiltresChambresSheetState();
}

class _FiltresChambresSheetState extends State<_FiltresChambresSheet> {
  TypeChambre? _type;
  StatutChambre? _statut;
  RangeValues _prix = const RangeValues(0, 50000);

  @override
  void initState() {
    super.initState();
    _type = widget.roomProvider.filtreType;
    _statut = widget.roomProvider.filtreStatut;
    _prix = widget.roomProvider.filtrePrix ?? const RangeValues(0, 50000);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filtrer les chambres', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          DropdownButtonFormField<TypeChambre?>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: [
              const DropdownMenuItem(value: null, child: Text('Tous les types')),
              ...TypeChambre.values.map((t) => DropdownMenuItem(value: t, child: Text(t.libelle))),
            ],
            onChanged: (v) => setState(() => _type = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<StatutChambre?>(
            initialValue: _statut,
            decoration: const InputDecoration(labelText: 'Statut'),
            items: [
              const DropdownMenuItem(value: null, child: Text('Tous les statuts')),
              ...StatutChambre.values.map((s) => DropdownMenuItem(value: s, child: Text(s.libelle))),
            ],
            onChanged: (v) => setState(() => _statut = v),
          ),
          const SizedBox(height: 12),
          Text('Prix : ${_prix.start.round()} - ${_prix.end.round()} DA', style: Theme.of(context).textTheme.bodyMedium),
          RangeSlider(
            values: _prix,
            min: 0,
            max: 50000,
            divisions: 50,
            activeColor: Theme.of(context).colorScheme.secondary,
            onChanged: (v) => setState(() => _prix = v),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.roomProvider.reinitialiserFiltres();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Reinitialiser'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.roomProvider.filtrerParType(_type);
                    widget.roomProvider.filtrerParStatut(_statut);
                    widget.roomProvider.filtrerParPrix(_prix);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Appliquer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
