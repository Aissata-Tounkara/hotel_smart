import '../models/chambre.dart';
import '../models/paiement.dart';
import '../models/reservation.dart';
import '../repositories/payment_repository.dart';
import '../repositories/reservation_repository.dart';
import '../repositories/room_repository.dart';

/// Classe de calcul (pas de table SQLite dediee) qui agrege a la volee les
/// donnees de `rooms`, `reservations` et `payments` pour alimenter le
/// tableau de bord et l'ecran Statistiques (point 30, 32).
class Statistique {
  final int chambresDisponibles;
  final int chambresOccupees;
  final int chambresMaintenance;
  final int reservationsDuJour;
  final double chiffreAffairesMensuel;
  final double tauxOccupation;

  const Statistique({
    required this.chambresDisponibles,
    required this.chambresOccupees,
    required this.chambresMaintenance,
    required this.reservationsDuJour,
    required this.chiffreAffairesMensuel,
    required this.tauxOccupation,
  });
}

/// Revenu total agrege par type de chambre, pour le graphique de l'ecran
/// Statistiques (point 32).
class RevenuParType {
  final TypeChambre type;
  final double montant;
  const RevenuParType(this.type, this.montant);
}

/// Taux d'occupation d'un mois donne (annee/mois), pour le graphique en
/// barres de l'ecran Statistiques (point 32).
class OccupationMensuelle {
  final int annee;
  final int mois;
  final double taux;
  const OccupationMensuelle(this.annee, this.mois, this.taux);
}

class StatisticsService {
  final RoomRepository _roomRepository;
  final ReservationRepository _reservationRepository;
  final PaymentRepository _paymentRepository;

  StatisticsService({
    RoomRepository? roomRepository,
    ReservationRepository? reservationRepository,
    PaymentRepository? paymentRepository,
  })  : _roomRepository = roomRepository ?? RoomRepository(),
        _reservationRepository = reservationRepository ?? ReservationRepository(),
        _paymentRepository = paymentRepository ?? PaymentRepository();

  Future<Statistique> calculerStatistiquesGlobales() async {
    final chambres = await _roomRepository.getAll();
    final reservations = await _reservationRepository.getAll();
    final paiements = await _paymentRepository.getAll();

    final disponibles = chambres.where((c) => c.statut == StatutChambre.disponible).length;
    final occupees = chambres.where((c) => c.statut == StatutChambre.occupee).length;
    final maintenance = chambres.where((c) => c.statut == StatutChambre.maintenance).length;

    final maintenant = DateTime.now();
    final aujourdhui = DateTime(maintenant.year, maintenant.month, maintenant.day);
    final reservationsDuJour = reservations.where((r) {
      final arrivee = DateTime(r.dateArrivee.year, r.dateArrivee.month, r.dateArrivee.day);
      final depart = DateTime(r.dateDepart.year, r.dateDepart.month, r.dateDepart.day);
      return r.statut != StatutReservation.annulee &&
          !aujourdhui.isBefore(arrivee) &&
          aujourdhui.isBefore(depart);
    }).length;

    final debutMois = DateTime(maintenant.year, maintenant.month, 1);
    final chiffreAffairesMensuel = paiements
        .where((p) =>
            p.statut == StatutPaiement.paye &&
            !p.datePaiement.isBefore(debutMois) &&
            p.datePaiement.isBefore(DateTime(maintenant.year, maintenant.month + 1, 1)))
        .fold<double>(0, (total, p) => total + p.montant);

    final tauxOccupation = chambres.isEmpty ? 0.0 : (occupees / chambres.length) * 100;

    return Statistique(
      chambresDisponibles: disponibles,
      chambresOccupees: occupees,
      chambresMaintenance: maintenance,
      reservationsDuJour: reservationsDuJour,
      chiffreAffairesMensuel: chiffreAffairesMensuel,
      tauxOccupation: tauxOccupation,
    );
  }

  /// Revenu total (paiements payes) regroupe par type de chambre.
  Future<List<RevenuParType>> revenuParTypeChambre() async {
    final chambres = await _roomRepository.getAll();
    final reservations = await _reservationRepository.getAll();
    final paiements = await _paymentRepository.getAll();

    final chambresParId = {for (final c in chambres) c.id: c};
    final reservationsParId = {for (final r in reservations) r.id: r};

    final totaux = {for (final t in TypeChambre.values) t: 0.0};

    for (final paiement in paiements) {
      if (paiement.statut != StatutPaiement.paye) continue;
      final reservation = reservationsParId[paiement.reservationId];
      if (reservation == null) continue;
      final chambre = chambresParId[reservation.chambreId];
      if (chambre == null) continue;
      totaux[chambre.type] = (totaux[chambre.type] ?? 0) + paiement.montant;
    }

    return totaux.entries.map((e) => RevenuParType(e.key, e.value)).toList();
  }

  /// Taux d'occupation moyen des [nombreDeMois] derniers mois (inclus le
  /// mois courant), calcule a partir du nombre de nuits reservees par
  /// rapport a la capacite totale (nombre de chambres x jours du mois).
  Future<List<OccupationMensuelle>> occupationParMois({int nombreDeMois = 6}) async {
    final chambres = await _roomRepository.getAll();
    final reservations = await _reservationRepository.getAll();
    final nombreChambres = chambres.isEmpty ? 1 : chambres.length;

    final maintenant = DateTime.now();
    final resultats = <OccupationMensuelle>[];

    for (int i = nombreDeMois - 1; i >= 0; i--) {
      final moisCible = DateTime(maintenant.year, maintenant.month - i, 1);
      final debutMois = DateTime(moisCible.year, moisCible.month, 1);
      final finMois = DateTime(moisCible.year, moisCible.month + 1, 1);
      final joursDansLeMois = finMois.difference(debutMois).inDays;

      int nuitsReservees = 0;
      for (final r in reservations) {
        if (r.statut == StatutReservation.annulee) continue;
        final debutChevauchement = r.dateArrivee.isAfter(debutMois) ? r.dateArrivee : debutMois;
        final finChevauchement = r.dateDepart.isBefore(finMois) ? r.dateDepart : finMois;
        final nuits = finChevauchement.difference(debutChevauchement).inDays;
        if (nuits > 0) nuitsReservees += nuits;
      }

      final capaciteTotale = nombreChambres * joursDansLeMois;
      final taux = capaciteTotale == 0 ? 0.0 : (nuitsReservees / capaciteTotale) * 100;
      resultats.add(OccupationMensuelle(moisCible.year, moisCible.month, taux.clamp(0, 100)));
    }

    return resultats;
  }
}
