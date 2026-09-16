import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Message affiche lorsqu'une liste (chambres, reservations, clients...)
/// est vide, plutot que de laisser un ecran blanc silencieux.
class EmptyState extends StatelessWidget {
  final IconData icone;
  final String message;

  const EmptyState({super.key, required this.icone, required this.message});

  @override
  Widget build(BuildContext context) {
    final or = Theme.of(context).colorScheme.secondary;
    final couleurTexte = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 48, color: or.withValues(alpha: 0.6)),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTheme.manrope(color: couleurTexte.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
