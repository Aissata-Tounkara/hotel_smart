import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Separateur signature de Hotel Smart : un losange dore au centre entre
/// deux traits fins. A utiliser entre les sections d'un ecran (profil,
/// formulaires, listes...) a la place d'un [Divider] Material generique.
class OrnamentalDivider extends StatelessWidget {
  final Color? color;

  const OrnamentalDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final couleur = color ?? AppTheme.or;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: couleur.withValues(alpha: 0.35), thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: couleur,
                  border: Border.all(color: couleur.withValues(alpha: 0.6)),
                ),
              ),
            ),
          ),
          Expanded(child: Divider(color: couleur.withValues(alpha: 0.35), thickness: 1)),
        ],
      ),
    );
  }
}
