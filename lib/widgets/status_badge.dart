import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Badge de statut reutilisable, coins legerement arrondis (jamais de
/// pastille "pilule"), pour afficher un statut (chambre, reservation,
/// paiement) de maniere coherente avec le design premium de l'application.
class StatusBadge extends StatelessWidget {
  final String texte;
  final Color couleur;

  const StatusBadge({super.key, required this.texte, required this.couleur});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: couleur.withValues(alpha: 0.45)),
      ),
      child: Text(
        texte,
        style: AppTheme.manrope(color: couleur, fontWeight: FontWeight.w700, fontSize: 11.5),
      ),
    );
  }
}
