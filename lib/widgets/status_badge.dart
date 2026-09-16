import 'package:flutter/material.dart';

/// Badge colore reutilisable pour afficher un statut (chambre, reservation,
/// paiement) de maniere coherente dans toute l'application.
class StatusBadge extends StatelessWidget {
  final String texte;
  final Color couleur;

  const StatusBadge({super.key, required this.texte, required this.couleur});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: couleur.withValues(alpha: 0.4)),
      ),
      child: Text(
        texte,
        style: TextStyle(color: couleur, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
