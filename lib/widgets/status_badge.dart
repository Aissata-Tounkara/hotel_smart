import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Badge de statut reutilisable : pastille de couleur + texte dans la
/// couleur normale du theme (jamais le texte colore directement), pour
/// garantir un contraste suffisant aussi bien en theme clair que sombre.
/// Coins legerement arrondis (jamais de pastille "pilule").
class StatusBadge extends StatelessWidget {
  final String texte;
  final Color couleur;

  const StatusBadge({super.key, required this.texte, required this.couleur});

  @override
  Widget build(BuildContext context) {
    final couleurTexte = Theme.of(context).textTheme.bodyMedium?.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: couleur.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: couleur, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            texte,
            style: AppTheme.manrope(color: couleurTexte, fontWeight: FontWeight.w700, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
