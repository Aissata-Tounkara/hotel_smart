import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/chambre.dart';
import '../models/paiement.dart';
import '../models/reservation.dart';
import 'app_theme.dart';

/// Helpers d'affichage partages (couleurs de statut, formatage
/// dates/montants) pour garder une UI coherente entre les ecrans.
///
/// Les couleurs de statut passent toutes par [AppTheme] (jamais de
/// `Colors.green`/`Colors.orange` Material generiques) pour rester dans
/// le systeme de design premium bleu nuit/or.
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
        return AppTheme.succes;
      case StatutChambre.occupee:
        return AppTheme.alerte;
      case StatutChambre.maintenance:
        return AppTheme.danger;
    }
  }

  static Color couleurStatutReservation(StatutReservation statut) {
    switch (statut) {
      case StatutReservation.enAttente:
        return AppTheme.alerte;
      case StatutReservation.confirmee:
        return AppTheme.bleuNuitSurface;
      case StatutReservation.annulee:
        return AppTheme.danger;
      case StatutReservation.terminee:
        return AppTheme.neutre;
    }
  }

  static Color couleurStatutPaiement(StatutPaiement statut) {
    switch (statut) {
      case StatutPaiement.paye:
        return AppTheme.succes;
      case StatutPaiement.enAttente:
        return AppTheme.alerte;
      case StatutPaiement.rembourse:
        return AppTheme.neutre;
    }
  }
}
