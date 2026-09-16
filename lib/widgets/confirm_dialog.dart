import 'package:flutter/material.dart';

/// Boite de dialogue de confirmation reutilisable avant une action
/// destructive (suppression) ou sensible (changement de statut).
Future<bool> afficherConfirmation(
  BuildContext context, {
  required String titre,
  required String message,
  String texteConfirmer = 'Confirmer',
  bool destructif = false,
}) async {
  final resultat = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titre),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: destructif
              ? FilledButton.styleFrom(backgroundColor: Colors.red)
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(texteConfirmer),
        ),
      ],
    ),
  );
  return resultat ?? false;
}
