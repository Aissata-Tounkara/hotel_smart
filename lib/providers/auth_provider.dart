import 'package:flutter/foundation.dart';

import '../models/utilisateur.dart';
import '../services/auth_service.dart';

enum AuthStatus { inconnu, connecte, deconnecte }

/// Etat global de session utilisateur, ecoute par l'UI pour adapter la
/// navigation et les permissions selon le role connecte.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService}) : _authService = authService ?? AuthService();

  Utilisateur? _utilisateurCourant;
  AuthStatus _status = AuthStatus.inconnu;
  String? _erreur;
  bool _enChargement = false;

  Utilisateur? get utilisateurCourant => _utilisateurCourant;
  AuthStatus get status => _status;
  String? get erreur => _erreur;
  bool get enChargement => _enChargement;
  bool get estConnecte => _utilisateurCourant != null;

  RoleUtilisateur? get role => _utilisateurCourant?.role;
  bool get estAdmin => role == RoleUtilisateur.admin;
  bool get estReceptionniste => role == RoleUtilisateur.receptionniste;
  bool get estClient => role == RoleUtilisateur.client;
  bool get peutGererOperations => estAdmin || estReceptionniste;

  Future<void> tenterRestaurationSession() async {
    _utilisateurCourant = await _authService.restoreSession();
    _status = _utilisateurCourant != null ? AuthStatus.connecte : AuthStatus.deconnecte;
    notifyListeners();
  }

  Future<bool> login(String email, String motDePasse) async {
    _enChargement = true;
    _erreur = null;
    notifyListeners();
    try {
      _utilisateurCourant = await _authService.login(email, motDePasse);
      _status = AuthStatus.connecte;
      return true;
    } on AuthException catch (e) {
      _erreur = e.message;
      _status = AuthStatus.deconnecte;
      return false;
    } catch (e) {
      _erreur = 'Erreur inattendue : impossible de se connecter';
      _status = AuthStatus.deconnecte;
      return false;
    } finally {
      _enChargement = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _utilisateurCourant = null;
    _status = AuthStatus.deconnecte;
    notifyListeners();
  }

  Future<bool> mettreAJourProfil({
    required String nom,
    required String email,
    String? nouveauMotDePasse,
  }) async {
    if (_utilisateurCourant == null) return false;
    _enChargement = true;
    _erreur = null;
    notifyListeners();
    try {
      _utilisateurCourant = await _authService.updateProfile(
        utilisateurActuel: _utilisateurCourant!,
        nom: nom,
        email: email,
        nouveauMotDePasse: nouveauMotDePasse,
      );
      return true;
    } on AuthException catch (e) {
      _erreur = e.message;
      return false;
    } finally {
      _enChargement = false;
      notifyListeners();
    }
  }

  void effacerErreur() {
    _erreur = null;
    notifyListeners();
  }
}
