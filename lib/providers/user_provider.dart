import 'package:flutter/foundation.dart';

import '../models/utilisateur.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';

/// Etat global de la gestion des utilisateurs (reserve a l'Admin) : CRUD
/// complet, y compris la creation manuelle d'un compte Client lie a une
/// fiche client existante (point 16).
class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  final AuthService _authService;

  UserProvider({UserRepository? userRepository, AuthService? authService})
      : _userRepository = userRepository ?? UserRepository(),
        _authService = authService ?? AuthService();

  List<Utilisateur> _utilisateurs = [];
  bool _enChargement = false;
  String? _erreur;

  bool get enChargement => _enChargement;
  String? get erreur => _erreur;
  List<Utilisateur> get utilisateurs => _utilisateurs;

  Future<void> charger() async {
    _enChargement = true;
    _erreur = null;
    notifyListeners();
    try {
      _utilisateurs = await _userRepository.getAll();
    } catch (e) {
      _erreur = 'Impossible de charger les utilisateurs';
    } finally {
      _enChargement = false;
      notifyListeners();
    }
  }

  Future<bool> creer({
    required String nom,
    required String email,
    required String motDePasse,
    required RoleUtilisateur role,
    int? clientId,
  }) async {
    try {
      final emailNormalise = email.trim().toLowerCase();
      if (await _userRepository.emailExists(emailNormalise)) {
        _erreur = 'Cet email est deja utilise';
        notifyListeners();
        return false;
      }
      final utilisateur = Utilisateur(
        nom: nom.trim(),
        email: emailNormalise,
        motDePasseHache: _authService.hashPassword(motDePasse),
        role: role,
        clientId: clientId,
        dateCreation: DateTime.now(),
      );
      await _userRepository.create(utilisateur);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible de creer l\'utilisateur';
      notifyListeners();
      return false;
    }
  }

  Future<bool> modifier({
    required Utilisateur utilisateur,
    required String nom,
    required String email,
    String? nouveauMotDePasse,
    required RoleUtilisateur role,
    int? clientId,
  }) async {
    try {
      final emailNormalise = email.trim().toLowerCase();
      if (await _userRepository.emailExists(emailNormalise, excludeId: utilisateur.id)) {
        _erreur = 'Cet email est deja utilise';
        notifyListeners();
        return false;
      }
      final miseAJour = utilisateur.copyWith(
        nom: nom.trim(),
        email: emailNormalise,
        motDePasseHache: (nouveauMotDePasse != null && nouveauMotDePasse.isNotEmpty)
            ? _authService.hashPassword(nouveauMotDePasse)
            : utilisateur.motDePasseHache,
        role: role,
        clientId: clientId,
        clearClientId: clientId == null,
      );
      await _userRepository.update(miseAJour);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible de modifier l\'utilisateur';
      notifyListeners();
      return false;
    }
  }

  Future<bool> supprimer(int id) async {
    try {
      await _userRepository.delete(id);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible de supprimer l\'utilisateur';
      notifyListeners();
      return false;
    }
  }

  void effacerErreur() {
    _erreur = null;
    notifyListeners();
  }
}
