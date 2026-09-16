import '../models/chambre.dart';
import '../models/reservation.dart';
import '../repositories/reservation_repository.dart';
import '../repositories/room_repository.dart';

/// Exception dediee aux regles metier de reservation (conflit de dates,
/// dates invalides), pour un message clair cote UI.
class ReservationException implements Exception {
  final String message;
  ReservationException(this.message);
  @override
  String toString() => message;
}

/// Regles metier de la reservation : verification des conflits de dates,
/// calcul du montant total, recherche des chambres disponibles pour une
/// periode donnee (point 21, 22, 23 du cahier des charges).
class ReservationService {
  final ReservationRepository _reservationRepository;
  final RoomRepository _roomRepository;

  ReservationService({
    ReservationRepository? reservationRepository,
    RoomRepository? roomRepository,
  })  : _reservationRepository = reservationRepository ?? ReservationRepository(),
        _roomRepository = roomRepository ?? RoomRepository();

  /// Calcule le montant total : tarif journalier x duree du sejour.
  double calculerMontantTotal(Chambre chambre, DateTime arrivee, DateTime depart) {
    final duree = depart.difference(arrivee).inDays;
    return chambre.prixParNuit * duree;
  }

  /// Renvoie la liste des chambres qui n'ont AUCUNE reservation active en
  /// conflit avec la periode [arrivee, depart).
  Future<List<Chambre>> getChambresDisponibles(
    DateTime arrivee,
    DateTime depart, {
    int? excludeReservationId,
  }) async {
    if (!depart.isAfter(arrivee)) {
      throw ReservationException('La date de depart doit etre posterieure a la date d\'arrivee');
    }

    final toutesLesChambres = await _roomRepository.getAll();
    final chambresDisponibles = <Chambre>[];

    for (final chambre in toutesLesChambres) {
      if (chambre.statut == StatutChambre.maintenance) continue;
      final reservationsChambre = await _reservationRepository.getByRoom(
        chambre.id!,
        excludeReservationId: excludeReservationId,
      );
      final enConflit = reservationsChambre.any((r) => r.chevauche(arrivee, depart));
      if (!enConflit) {
        chambresDisponibles.add(chambre);
      }
    }
    return chambresDisponibles;
  }

  /// Cree une reservation apres avoir revalide l'absence de conflit de dates.
  Future<Reservation> creerReservation({
    required int clientId,
    required Chambre chambre,
    required DateTime arrivee,
    required DateTime depart,
  }) async {
    if (!depart.isAfter(arrivee)) {
      throw ReservationException('La date de depart doit etre posterieure a la date d\'arrivee');
    }

    final reservationsChambre = await _reservationRepository.getByRoom(chambre.id!);
    final enConflit = reservationsChambre.any((r) => r.chevauche(arrivee, depart));
    if (enConflit) {
      throw ReservationException('Cette chambre est deja reservee sur une periode qui chevauche ces dates');
    }

    final montant = calculerMontantTotal(chambre, arrivee, depart);
    final reservation = Reservation(
      clientId: clientId,
      chambreId: chambre.id!,
      dateArrivee: arrivee,
      dateDepart: depart,
      statut: StatutReservation.enAttente,
      montantTotal: montant,
      dateCreation: DateTime.now(),
    );
    final id = await _reservationRepository.create(reservation);
    return reservation.copyWith(id: id);
  }

  /// Check-in : confirme la reservation et passe la chambre en "occupee"
  /// (point 25).
  Future<void> effectuerCheckIn(Reservation reservation) async {
    await _reservationRepository.update(reservation.copyWith(statut: StatutReservation.confirmee));
    final chambre = await _roomRepository.getById(reservation.chambreId);
    if (chambre != null) {
      await _roomRepository.update(chambre.copyWith(statut: StatutChambre.occupee));
    }
  }

  /// Check-out : termine la reservation et remet la chambre "disponible"
  /// (point 25).
  Future<void> effectuerCheckOut(Reservation reservation) async {
    await _reservationRepository.update(reservation.copyWith(statut: StatutReservation.terminee));
    final chambre = await _roomRepository.getById(reservation.chambreId);
    if (chambre != null) {
      await _roomRepository.update(chambre.copyWith(statut: StatutChambre.disponible));
    }
  }

  /// Annule une reservation en attente ou confirmee.
  Future<void> annuler(Reservation reservation) async {
    await _reservationRepository.update(reservation.copyWith(statut: StatutReservation.annulee));
    if (reservation.statut == StatutReservation.confirmee) {
      final chambre = await _roomRepository.getById(reservation.chambreId);
      if (chambre != null) {
        await _roomRepository.update(chambre.copyWith(statut: StatutChambre.disponible));
      }
    }
  }
}
