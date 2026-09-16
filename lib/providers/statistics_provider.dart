import 'package:flutter/foundation.dart';

import '../services/statistics_service.dart';

/// Etat global des statistiques agregees (tableau de bord + ecran
/// Statistiques) — point 30, 32.
class StatisticsProvider extends ChangeNotifier {
  final StatisticsService _statisticsService;

  StatisticsProvider({StatisticsService? statisticsService})
      : _statisticsService = statisticsService ?? StatisticsService();

  Statistique? _statistiques;
  List<RevenuParType> _revenuParType = [];
  List<OccupationMensuelle> _occupationParMois = [];
  bool _enChargement = false;

  Statistique? get statistiques => _statistiques;
  List<RevenuParType> get revenuParType => _revenuParType;
  List<OccupationMensuelle> get occupationParMois => _occupationParMois;
  bool get enChargement => _enChargement;

  Future<void> charger() async {
    _enChargement = true;
    notifyListeners();
    try {
      _statistiques = await _statisticsService.calculerStatistiquesGlobales();
      _revenuParType = await _statisticsService.revenuParTypeChambre();
      _occupationParMois = await _statisticsService.occupationParMois();
    } finally {
      _enChargement = false;
      notifyListeners();
    }
  }
}
