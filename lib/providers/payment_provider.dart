import 'package:flutter/foundation.dart';

import '../models/paiement.dart';
import '../repositories/payment_repository.dart';

/// Etat global des paiements : enregistrement et suivi du statut
/// (Paye / En attente / Rembourse) — point 33.
class PaymentProvider extends ChangeNotifier {
  final PaymentRepository _paymentRepository;

  PaymentProvider({PaymentRepository? paymentRepository})
      : _paymentRepository = paymentRepository ?? PaymentRepository();

  List<Paiement> _paiements = [];
  bool _enChargement = false;
  String? _erreur;

  bool get enChargement => _enChargement;
  String? get erreur => _erreur;
  List<Paiement> get paiements => _paiements;

  Future<void> charger() async {
    _enChargement = true;
    _erreur = null;
    notifyListeners();
    try {
      _paiements = await _paymentRepository.getAll();
    } catch (e) {
      _erreur = 'Impossible de charger les paiements';
    } finally {
      _enChargement = false;
      notifyListeners();
    }
  }

  Future<List<Paiement>> getPaiementsReservation(int reservationId) {
    return _paymentRepository.getByReservation(reservationId);
  }

  Future<bool> enregistrer(Paiement paiement) async {
    try {
      await _paymentRepository.create(paiement);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible d\'enregistrer le paiement';
      notifyListeners();
      return false;
    }
  }

  Future<bool> changerStatut(Paiement paiement, StatutPaiement statut) async {
    try {
      await _paymentRepository.update(paiement.copyWith(statut: statut));
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible de mettre a jour le paiement';
      notifyListeners();
      return false;
    }
  }

  void effacerErreur() {
    _erreur = null;
    notifyListeners();
  }
}
