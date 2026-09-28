import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<RoomProvider>().charger(),
    );
  }

  Future<void> _supprimer(BuildContext context, Chambre chambre) async {
    final l10n = AppLocalizations.of(context)!;
    final confirme = await afficherConfirmation(
      context,
      titre: l10n.deleteRoomTitle,
      message: l10n.deleteRoomConfirmation(chambre.numero),
      texteConfirmer: l10n.delete,
      texteAnnuler: l10n.cancel,
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
    final chambres = context.select<RoomProvider, List<Chambre>>(
      (provider) => provider.chambres,
    );
    final enChargement = context.select<RoomProvider, bool>(
      (provider) => provider.enChargement,
    );
    final peutGerer = context.select<AuthProvider, bool>(
      (provider) => provider.peutGererOperations,
    );
    final l10n = AppLocalizations.of(context)!;
    final roomProvider = context.read<RoomProvider>();

    return Scaffold(
      appBar: PremiumAppBar(
        title: l10n.rooms,
        actions: [
          IconButton(
            icon: Icon(_vueCarte ? Icons.view_list : Icons.grid_view),
            tooltip: _vueCarte ? l10n.viewList : l10n.viewCards,
            onPressed: () => setState(() => _vueCarte = !_vueCarte),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: l10n.filters,
            onPressed: () => _ouvrirFiltres(context),
          ),
        ],
      ),
      floatingActionButton: peutGerer
          ? FloatingActionButton(
              tooltip: l10n.addRoom,
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const RoomFormScreen())),
              child: const Icon(Icons.add),
            )
          : null,
      body: FadeSlideIn(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: AppTextField(
                label: l10n.searchRooms,
                icon: Icons.search,
                onChanged: (value) {
                  var recherche = value;
                  for (final type in TypeChambre.values) {
                    final libelleTraduit = _libelleTypeChambre(type, l10n);
                    if (libelleTraduit != type.libelle) {
                      recherche = recherche.replaceAll(
                        RegExp(
                          RegExp.escape(libelleTraduit),
                          caseSensitive: false,
                        ),
                        type.libelle,
                      );
                    }
                  }
                  roomProvider.rechercher(recherche);
                },
              ),
            ),
            Expanded(
              child: enChargement
                  ? const Center(child: CircularProgressIndicator())
                  : chambres.isEmpty
                  ? EmptyState(
                      icone: Icons.bed_outlined,
                      message: l10n.noRoomsFound,
                    )
                  : RefreshIndicator(
                      onRefresh: roomProvider.charger,
                      child: _vueCarte
                          ? GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                12,
                                20,
                                20,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.95,
                                  ),
                              itemCount: chambres.length,
                              itemBuilder: (context, i) => _CarteChambre(
                                chambre: chambres[i],
                                peutModifier: peutGerer,
                                onModifier: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RoomFormScreen(chambre: chambres[i]),
                                  ),
                                ),
                                onSupprimer: () =>
                                    _supprimer(context, chambres[i]),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: chambres.length,
                              itemBuilder: (context, i) {
                                final chambre = chambres[i];
                                return Semantics(
                                  label: l10n.roomSemanticSummary(
                                    chambre.numero,
                                    _libelleTypeChambre(chambre.type, l10n),
                                    _libelleStatutChambre(chambre.statut, l10n),
                                    UiHelpers.formatMontant(
                                      chambre.prixParNuit,
                                    ),
                                    chambre.etage.toString(),
                                  ),
                                  child: PremiumListTile(
                                    icon: Icons.meeting_room_outlined,
                                    title: l10n.roomNumberType(
                                      chambre.numero,
                                      _libelleTypeChambre(chambre.type, l10n),
                                    ),
                                    subtitle: l10n.roomPriceAndFloor(
                                      UiHelpers.formatMontant(
                                        chambre.prixParNuit,
                                      ),
                                      chambre.etage.toString(),
                                    ),
                                    onTap: peutGerer
                                        ? () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => RoomFormScreen(
                                                chambre: chambre,
                                              ),
                                            ),
                                          )
                                        : null,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        StatusBadge(
                                          texte: _libelleStatutChambre(
                                            chambre.statut,
                                            l10n,
                                          ),
                                          couleur:
                                              UiHelpers.couleurStatutChambre(
                                                chambre.statut,
                                              ),
                                        ),
                                        if (peutGerer)
                                          PopupMenuButton<String>(
                                            onSelected: (v) => v == 'modifier'
                                                ? Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          RoomFormScreen(
                                                            chambre: chambre,
                                                          ),
                                                    ),
                                                  )
                                                : _supprimer(context, chambre),
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 'modifier',
                                                child: Text(l10n.edit),
                                              ),
                                              PopupMenuItem(
                                                value: 'supprimer',
                                                child: Text(l10n.delete),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
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
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.roomSemanticSummary(
        chambre.numero,
        _libelleTypeChambre(chambre.type, l10n),
        _libelleStatutChambre(chambre.statut, l10n),
        UiHelpers.formatMontant(chambre.prixParNuit),
        chambre.etage.toString(),
      ),
      child: InkWell(
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
                      onSelected: (v) =>
                          v == 'modifier' ? onModifier() : onSupprimer(),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'modifier',
                          child: Text(l10n.edit),
                        ),
                        PopupMenuItem(
                          value: 'supprimer',
                          child: Text(l10n.delete),
                        ),
                      ],
                    ),
                ],
              ),
              const Spacer(),
              Text(
                l10n.roomNumber(chambre.numero),
                style: AppTheme.playfair(fontSize: 17),
              ),
              Text(
                _libelleTypeChambre(chambre.type, l10n),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                UiHelpers.formatMontant(chambre.prixParNuit),
                style: AppTheme.manrope(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              StatusBadge(
                texte: _libelleStatutChambre(chambre.statut, l10n),
                couleur: UiHelpers.couleurStatutChambre(chambre.statut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _libelleTypeChambre(TypeChambre type, AppLocalizations l10n) =>
    switch (type) {
      TypeChambre.simple => l10n.roomTypeSingle,
      TypeChambre.double_ => l10n.roomTypeDouble,
      TypeChambre.suite => l10n.roomTypeSuite,
    };

String _libelleStatutChambre(StatutChambre statut, AppLocalizations l10n) =>
    switch (statut) {
      StatutChambre.disponible => l10n.roomStatusAvailable,
      StatutChambre.occupee => l10n.roomStatusOccupied,
      StatutChambre.maintenance => l10n.roomStatusMaintenance,
    };

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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.filterRooms, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          DropdownButtonFormField<TypeChambre?>(
            initialValue: _type,
            decoration: InputDecoration(labelText: l10n.roomTypeField),
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.allRoomTypes)),
              ...TypeChambre.values.map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(_libelleTypeChambre(t, l10n)),
                ),
              ),
            ],
            onChanged: (v) => setState(() => _type = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<StatutChambre?>(
            initialValue: _statut,
            decoration: InputDecoration(labelText: l10n.roomStatusField),
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.allRoomStatuses)),
              ...StatutChambre.values.map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(_libelleStatutChambre(s, l10n)),
                ),
              ),
            ],
            onChanged: (v) => setState(() => _statut = v),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.priceRange(
              _prix.start.round().toString(),
              _prix.end.round().toString(),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
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
                  child: Text(l10n.reset),
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
                  child: Text(l10n.apply),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
