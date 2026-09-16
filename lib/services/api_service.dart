import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

/// Exception dediee aux erreurs reseau/API, pour un message clair cote UI
/// (timeout, absence de connexion, erreur serveur) au lieu d'un crash silencieux.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// Integration de l'API REST publique restcountries.com pour peupler la
/// liste des nationalites dans le formulaire client (point 27).
class ApiService {
  Future<List<String>> getNationalites() async {
    try {
      final reponse = await http
          .get(Uri.parse(AppConstants.restCountriesUrl))
          .timeout(const Duration(seconds: 10));

      if (reponse.statusCode != 200) {
        throw ApiException('Le serveur des nationalites a repondu avec une erreur (${reponse.statusCode})');
      }

      final data = jsonDecode(reponse.body) as List<dynamic>;
      final nationalites = data
          .map((pays) {
            final nomCommun = pays['name']?['common'];
            return nomCommun is String ? nomCommun : null;
          })
          .whereType<String>()
          .toList();

      nationalites.sort();
      if (nationalites.isEmpty) {
        throw ApiException('Aucune nationalite recue depuis le serveur');
      }
      return nationalites;
    } on SocketException {
      throw ApiException('Pas de connexion internet : verifiez votre reseau');
    } on HttpException {
      throw ApiException('Erreur de communication avec le serveur');
    } on FormatException {
      throw ApiException('Reponse invalide recue du serveur');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Impossible de recuperer les nationalites : delai depasse ou erreur inattendue');
    }
  }
}
