import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chambre.dart';
import '../models/paiement.dart';
import '../models/reservation.dart';

/// Helpers d'affichage partages (couleurs de statut, formatage
/// dates/montants) pour garder une UI coherente entre les ecrans.
class UiHelpers {
  UiHelpers._();

  static final NumberFormat _formatMontant = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'DA',
    decimalDigits: 0,
  );

  static final DateFormat _formatDateCourt = DateFormat('dd/MM/yyyy');

  static String formatMontant(double montant) => _formatMontant.format(montant);

  static String formatDate(DateTime date) => _formatDateCourt.format(date);

  static Color couleurStatutChambre(StatutChambre statut) {
    switch (statut) {
      case StatutChambre.disponible:
        return Colors.green;
      case StatutChambre.occupee:
        return Colors.orange;
      case StatutChambre.maintenance:
        return Colors.red;
    }
  }

  static Color couleurStatutReservation(StatutReservation statut) {
    switch (statut) {
      case StatutReservation.enAttente:
        return Colors.orange;
      case StatutReservation.confirmee:
        return Colors.blue;
      case StatutReservation.annulee:
        return Colors.red;
      case StatutReservation.terminee:
        return Colors.grey;
    }
  }

  static Color couleurStatutPaiement(StatutPaiement statut) {
    switch (statut) {
      case StatutPaiement.paye:
        return Colors.green;
      case StatutPaiement.enAttente:
        return Colors.orange;
      case StatutPaiement.rembourse:
        return Colors.blueGrey;
    }
  }
}
