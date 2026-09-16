import 'dart:convert';

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

/// Resultat de la recuperation des nationalites : la liste elle-meme, et
/// si elle provient de la liste de secours locale (pour informer
/// l'utilisateur sans jamais bloquer le formulaire).
class NationalitesResultat {
  final List<String> nationalites;
  final bool depuisListeDeSecours;
  const NationalitesResultat({required this.nationalites, required this.depuisListeDeSecours});
}

/// Integration de l'API REST publique countries.dev pour peupler la liste
/// des nationalites dans le formulaire client (point 27).
///
/// En cas d'echec (pas de reseau, service tiers en panne, timeout), une
/// liste de secours locale est utilisee automatiquement : le formulaire
/// client ne doit jamais rester bloque a cause d'un service externe non
/// fiable, en particulier le jour d'une demonstration (point 28, 38).
class ApiService {
  final http.Client _client;

  /// [client] est injectable pour les tests unitaires (simuler une panne
  /// reseau sans dependre d'un vrai serveur).
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Liste de secours (30 nationalites courantes), utilisee des que l'appel
  /// reseau echoue pour n'importe quelle raison.
  static const List<String> _nationalitesSecours = [
    'Algeria',
    'France',
    'Morocco',
    'Tunisia',
    'Spain',
    'Italy',
    'Germany',
    'United Kingdom of Great Britain and Northern Ireland',
    'United States of America',
    'Canada',
    'Belgium',
    'Switzerland',
    'Netherlands',
    'Saudi Arabia',
    'United Arab Emirates',
    'Qatar',
    'Kuwait',
    'Egypt',
    'Turkey',
    'China',
    'Russian Federation',
    'Portugal',
    'Sweden',
    'Norway',
    'Libya',
    'Mauritania',
    'Senegal',
    'Mali',
    'Jordan',
    'Lebanon',
  ];

  Future<NationalitesResultat> getNationalites() async {
    try {
      final reponse = await _client
          .get(Uri.parse(AppConstants.countriesApiUrl))
          .timeout(const Duration(seconds: 15));

      if (reponse.statusCode != 200) {
        throw ApiException('Le serveur des nationalites a repondu avec une erreur (${reponse.statusCode})');
      }

      final data = jsonDecode(reponse.body) as List<dynamic>;
      final nationalites = data
          .map((pays) {
            final nom = pays['name'];
            return nom is String ? nom : null;
          })
          .whereType<String>()
          .toList();

      if (nationalites.isEmpty) {
        throw ApiException('Aucune nationalite recue depuis le serveur');
      }
      nationalites.sort();
      return NationalitesResultat(nationalites: nationalites, depuisListeDeSecours: false);
    } catch (_) {
      // Quelle que soit la cause (pas de connexion, timeout, erreur
      // serveur, reponse invalide), on retombe sur la liste de secours
      // plutot que de bloquer le formulaire client.
      final secours = List<String>.from(_nationalitesSecours)..sort();
      return NationalitesResultat(nationalites: secours, depuisListeDeSecours: true);
    }
  }
}
