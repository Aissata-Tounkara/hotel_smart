import 'package:flutter/foundation.dart';

import '../models/client.dart';
import '../repositories/client_repository.dart';
import '../services/api_service.dart';

/// Etat global des clients : CRUD, recherche, et liste des nationalites
/// recuperee depuis l'API countries.dev (point 26, 27, 28).
class ClientProvider extends ChangeNotifier {
  final ClientRepository _clientRepository;
  final ApiService _apiService;

  ClientProvider({ClientRepository? clientRepository, ApiService? apiService})
      : _clientRepository = clientRepository ?? ClientRepository(),
        _apiService = apiService ?? ApiService();

  List<Client> _clients = [];
  List<String> _nationalites = [];
  bool _enChargement = false;
  bool _chargementNationalites = false;
  String? _erreur;
  bool _nationalitesDepuisSecours = false;
  String _recherche = '';

  bool get enChargement => _enChargement;
  bool get chargementNationalites => _chargementNationalites;
  String? get erreur => _erreur;
  bool get nationalitesDepuisSecours => _nationalitesDepuisSecours;
  List<String> get nationalites => _nationalites;

  List<Client> get clients {
    if (_recherche.isEmpty) return _clients;
    final q = _recherche.toLowerCase();
    return _clients.where((c) {
      return c.nom.toLowerCase().contains(q) ||
          c.prenom.toLowerCase().contains(q) ||
          c.telephone.contains(q) ||
          c.email.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> charger() async {
    _enChargement = true;
    _erreur = null;
    notifyListeners();
    try {
      _clients = await _clientRepository.getAll();
    } catch (e) {
      _erreur = 'Impossible de charger les clients';
    } finally {
      _enChargement = false;
      notifyListeners();
    }
  }

  Future<void> chargerNationalites() async {
    _chargementNationalites = true;
    notifyListeners();
    final resultat = await _apiService.getNationalites();
    _nationalites = resultat.nationalites;
    _nationalitesDepuisSecours = resultat.depuisListeDeSecours;
    _chargementNationalites = false;
    notifyListeners();
  }

  void rechercher(String texte) {
    _recherche = texte;
    notifyListeners();
  }

  Future<bool> ajouter(Client client) async {
    try {
      await _clientRepository.create(client);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible d\'ajouter le client';
      notifyListeners();
      return false;
    }
  }

  Future<bool> modifier(Client client) async {
    try {
      await _clientRepository.update(client);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible de modifier le client';
      notifyListeners();
      return false;
    }
  }

  Future<bool> supprimer(int id) async {
    try {
      await _clientRepository.delete(id);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible de supprimer le client : il possede peut-etre des reservations';
      notifyListeners();
      return false;
    }
  }

  void effacerErreur() {
    _erreur = null;
    notifyListeners();
  }
}
