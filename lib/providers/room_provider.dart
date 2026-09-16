import 'package:flutter/material.dart' show ChangeNotifier, RangeValues;

import '../models/chambre.dart';
import '../repositories/room_repository.dart';

/// Etat global des chambres : liste complete + filtres (type, statut,
/// prix) + recherche temps reel par numero/type (points 17 a 20).
class RoomProvider extends ChangeNotifier {
  final RoomRepository _roomRepository;

  RoomProvider({RoomRepository? roomRepository})
      : _roomRepository = roomRepository ?? RoomRepository();

  List<Chambre> _chambres = [];
  bool _enChargement = false;
  String? _erreur;

  String _recherche = '';
  TypeChambre? _filtreType;
  StatutChambre? _filtreStatut;
  RangeValues? _filtrePrix;

  bool get enChargement => _enChargement;
  String? get erreur => _erreur;
  TypeChambre? get filtreType => _filtreType;
  StatutChambre? get filtreStatut => _filtreStatut;
  RangeValues? get filtrePrix => _filtrePrix;

  List<Chambre> get chambres {
    return _chambres.where((chambre) {
      final correspondRecherche = _recherche.isEmpty ||
          chambre.numero.toLowerCase().contains(_recherche.toLowerCase()) ||
          chambre.type.libelle.toLowerCase().contains(_recherche.toLowerCase());
      final correspondType = _filtreType == null || chambre.type == _filtreType;
      final correspondStatut = _filtreStatut == null || chambre.statut == _filtreStatut;
      final correspondPrix = _filtrePrix == null ||
          (chambre.prixParNuit >= _filtrePrix!.start && chambre.prixParNuit <= _filtrePrix!.end);
      return correspondRecherche && correspondType && correspondStatut && correspondPrix;
    }).toList();
  }

  Future<void> charger() async {
    _enChargement = true;
    _erreur = null;
    notifyListeners();
    try {
      _chambres = await _roomRepository.getAll();
    } catch (e) {
      _erreur = 'Impossible de charger les chambres';
    } finally {
      _enChargement = false;
      notifyListeners();
    }
  }

  void rechercher(String texte) {
    _recherche = texte;
    notifyListeners();
  }

  void filtrerParType(TypeChambre? type) {
    _filtreType = type;
    notifyListeners();
  }

  void filtrerParStatut(StatutChambre? statut) {
    _filtreStatut = statut;
    notifyListeners();
  }

  void filtrerParPrix(RangeValues? plage) {
    _filtrePrix = plage;
    notifyListeners();
  }

  void reinitialiserFiltres() {
    _recherche = '';
    _filtreType = null;
    _filtreStatut = null;
    _filtrePrix = null;
    notifyListeners();
  }

  Future<bool> ajouter(Chambre chambre) async {
    try {
      if (await _roomRepository.numeroExists(chambre.numero)) {
        _erreur = 'Une chambre avec ce numero existe deja';
        notifyListeners();
        return false;
      }
      await _roomRepository.create(chambre);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible d\'ajouter la chambre';
      notifyListeners();
      return false;
    }
  }

  Future<bool> modifier(Chambre chambre) async {
    try {
      if (await _roomRepository.numeroExists(chambre.numero, excludeId: chambre.id)) {
        _erreur = 'Une chambre avec ce numero existe deja';
        notifyListeners();
        return false;
      }
      await _roomRepository.update(chambre);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible de modifier la chambre';
      notifyListeners();
      return false;
    }
  }

  Future<bool> supprimer(int id) async {
    try {
      await _roomRepository.delete(id);
      await charger();
      return true;
    } catch (e) {
      _erreur = 'Impossible de supprimer la chambre';
      notifyListeners();
      return false;
    }
  }

  void effacerErreur() {
    _erreur = null;
    notifyListeners();
  }
}
