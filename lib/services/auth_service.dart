import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/utilisateur.dart';
import '../repositories/user_repository.dart';
import '../utils/constants.dart';

/// Exception dediee pour un echec d'authentification, afin que l'UI puisse
/// afficher un message clair sans avoir a interpreter une erreur generique.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

/// Logique metier de l'authentification : hachage du mot de passe (SHA-256),
/// verification en base et gestion de la session via SharedPreferences.
class AuthService {
  final UserRepository _userRepository;

  AuthService({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository();

  String hashPassword(String motDePasse) {
    return sha256.convert(utf8.encode(motDePasse)).toString();
  }

  Future<Utilisateur> login(String email, String motDePasse) async {
    final utilisateur = await _userRepository.getByEmail(email.trim().toLowerCase());
    if (utilisateur == null) {
      throw AuthException('Aucun compte ne correspond a cet email');
    }
    final hache = hashPassword(motDePasse);
    if (hache != utilisateur.motDePasseHache) {
      throw AuthException('Mot de passe incorrect');
    }
    await _saveSession(utilisateur.id!);
    return utilisateur;
  }

  Future<void> _saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefUserId, userId);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefUserId);
  }

  /// Restaure la session en cours (utilisateur deja connecte precedemment),
  /// utile pour rester connecte au redemarrage de l'application.
  Future<Utilisateur?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(AppConstants.prefUserId);
    if (userId == null) return null;
    return _userRepository.getById(userId);
  }

  Future<Utilisateur> updateProfile({
    required Utilisateur utilisateurActuel,
    required String nom,
    required String email,
    String? nouveauMotDePasse,
  }) async {
    final emailNormalise = email.trim().toLowerCase();
    final existeDeja = await _userRepository.emailExists(
      emailNormalise,
      excludeId: utilisateurActuel.id,
    );
    if (existeDeja) {
      throw AuthException('Cet email est deja utilise par un autre compte');
    }

    final utilisateurMisAJour = utilisateurActuel.copyWith(
      nom: nom.trim(),
      email: emailNormalise,
      motDePasseHache: nouveauMotDePasse != null && nouveauMotDePasse.isNotEmpty
          ? hashPassword(nouveauMotDePasse)
          : utilisateurActuel.motDePasseHache,
    );
    await _userRepository.update(utilisateurMisAJour);
    return utilisateurMisAJour;
  }
}
