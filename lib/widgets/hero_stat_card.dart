import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Carte "heros" : met en avant UNE donnee cle (fond degrade bleu nuit,
/// valeur en grand Playfair Display, icone sur badge or). A utiliser sur
/// le dashboard et l'ecran Statistiques plutot qu'une grille de cartes
/// uniformes.
class HeroStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const HeroStatCard({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppTheme.degradeBleuNuit,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(gradient: AppTheme.degradeOr, borderRadius: BorderRadius.circular(4)),
            child: Icon(icon, color: AppTheme.bleuNuitProfond, size: 26),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTheme.playfair(
                    color: AppTheme.ivoire,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTheme.manrope(color: AppTheme.ivoire.withValues(alpha: 0.72), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Petite statistique secondaire (utilisee a cote de la carte heros),
/// sobre et non uniforme avec celle-ci.
class MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const MiniStat({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final couleurTexte = Theme.of(context).textTheme.bodyLarge?.color ?? AppTheme.encre;
    final or = Theme.of(context).colorScheme.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: or.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: or),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: AppTheme.manrope(fontWeight: FontWeight.w700, fontSize: 14, color: couleurTexte)),
              Text(label, style: AppTheme.manrope(fontSize: 11, color: couleurTexte.withValues(alpha: 0.6))),
            ],
          ),
        ],
      ),
    );
  }
}
