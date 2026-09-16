import 'package:flutter/foundation.dart';

import '../models/notification_alerte.dart';
import '../services/notification_service.dart';

/// Etat global des notifications locales de check-in/check-out (point 31).
class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService;

  NotificationProvider({NotificationService? notificationService})
      : _notificationService = notificationService ?? NotificationService();

  List<NotificationAlerte> _alertesNonLues = [];
  bool _enChargement = false;

  List<NotificationAlerte> get alertesNonLues => _alertesNonLues;
  bool get enChargement => _enChargement;

  /// Genere les nouvelles alertes du jour puis recharge la liste.
  Future<void> rafraichir() async {
    _enChargement = true;
    notifyListeners();
    try {
      await _notificationService.genererAlertesDuJour();
      _alertesNonLues = await _notificationService.getAlertesNonLues();
    } finally {
      _enChargement = false;
      notifyListeners();
    }
  }

  Future<void> marquerCommeLue(int id) async {
    await _notificationService.marquerCommeLue(id);
    _alertesNonLues = await _notificationService.getAlertesNonLues();
    notifyListeners();
  }
}
