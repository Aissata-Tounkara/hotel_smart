import 'package:flutter/foundation.dart';

import '../models/chambre.dart';
import '../models/reservation.dart';
import '../repositories/reservation_repository.dart';
import '../services/reservation_service.dart';

/// Etat global des reservations : creation (avec verification de conflit),
/// liste filtrable par statut, recherche, et changement de statut
/// (check-in / check-out) — points 21 a 25.
class ReservationProvider extends ChangeNotifier {
  final ReservationRepository _reservationRepository;
  final ReservationService _reservationService;

  ReservationProvider({
    ReservationRepository? reservationRepository,
    ReservationService? reservationService,
  })  : _reservationRepository = reservationRepository ?? ReservationRepository(),
        _reservationService = reservationService ?? ReservationService();

  List<Reservation> _reservations = [];
  List<Chambre> _chambresDisponibles = [];
  bool _enChargement = false;
  bool _rechercheChambresEnCours = false;
  String? _erreur;
  StatutReservation? _filtreStatut;

  bool get enChargement => _enChargement;
  bool get rechercheChambresEnCours => _rechercheChambresEnCours;
  String? get erreur => _erreur;
  StatutReservation? get filtreStatut => _filtreStatut;
  List<Chambre> get chambresDisponibles => _chambresDisponibles;

  List<Reservation> get reservations {
    return _reservations.where((r) {
      final correspondStatut = _filtreStatut == null || r.statut == _filtreStatut;
      return correspondStatut;
    }).toList();
  }

  Future<void> charger() async {
    _enChargement = true;
    _erreur = null;
    notifyListeners();
    try {
      _reservations = await _reservationRepository.getAll();
    } catch (e) {
      _erreur = 'Impossible de charger les reservations';
    } finally {
      _enChargement = false;
      notifyListeners();
    }
  }

  Future<List<Reservation>> getReservationsClient(int clientId) {
    return _reservationRepository.getByClient(clientId);
  }

  void filtrerParStatut(StatutReservation? statut) {
    _filtreStatut = statut;
    notifyListeners();
  }

  Future<void> chercherChambresDisponibles(DateTime arrivee, DateTime depart) async {
    _rechercheChambresEnCours = true;
    _erreur = null;
    _chambresDisponibles = [];
    notifyListeners();
    try {
      _chambresDisponibles = await _reservationService.getChambresDisponibles(arrivee, depart);
    } on ReservationException catch (e) {
      _erreur = e.message;
    } finally {
      _rechercheChambresEnCours = false;
      notifyListeners();
    }
  }

  double calculerMontant(Chambre chambre, DateTime arrivee, DateTime depart) {
    return _reservationService.calculerMontantTotal(chambre, arrivee, depart);
  }

  Future<bool> creerReservation({
    required int clientId,
    required Chambre chambre,
    required DateTime arrivee,
    required DateTime depart,
  }) async {
    try {
      await _reservationService.creerReservation(
        clientId: clientId,
        chambre: chambre,
        arrivee: arrivee,
        depart: depart,
      );
      await charger();
      return true;
    } on ReservationException catch (e) {
      _erreur = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _erreur = 'Impossible de creer la reservation';
      notifyListeners();
      return false;
    }
  }

  Future<bool> effectuerCheckIn(Reservation reservation) async {
    try {
      await _reservationService.effectuerCheckIn(reservation);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible d\'effectuer le check-in';
      notifyListeners();
      return false;
    }
  }

  Future<bool> effectuerCheckOut(Reservation reservation) async {
    try {
      await _reservationService.effectuerCheckOut(reservation);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible d\'effectuer le check-out';
      notifyListeners();
      return false;
    }
  }

  Future<bool> annuler(Reservation reservation) async {
    try {
      await _reservationService.annuler(reservation);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible d\'annuler la reservation';
      notifyListeners();
      return false;
    }
  }

  void effacerErreur() {
    _erreur = null;
    notifyListeners();
  }
}
