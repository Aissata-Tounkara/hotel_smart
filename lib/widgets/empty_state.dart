import 'package:flutter/material.dart';

/// Message affiche lorsqu'une liste (chambres, reservations, clients...)
/// est vide, plutot que de laisser un ecran blanc silencieux.
class EmptyState extends StatelessWidget {
  final IconData icone;
  final String message;

  const EmptyState({super.key, required this.icone, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
