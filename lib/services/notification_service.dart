import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/notification_alerte.dart';
import '../models/reservation.dart';
import '../repositories/notification_repository.dart';
import '../repositories/reservation_repository.dart';

/// Notifications locales de check-in/check-out du jour (point 31).
///
/// Chaque alerte generee est a la fois persistee dans la table
/// `notifications` (historique consultable dans l'app) et affichee comme
/// notification systeme via `flutter_local_notifications`.
class NotificationService {
  final NotificationRepository _notificationRepository;
  final ReservationRepository _reservationRepository;
  final FlutterLocalNotificationsPlugin _plugin;

  NotificationService({
    NotificationRepository? notificationRepository,
    ReservationRepository? reservationRepository,
    FlutterLocalNotificationsPlugin? plugin,
  })  : _notificationRepository = notificationRepository ?? NotificationRepository(),
        _reservationRepository = reservationRepository ?? ReservationRepository(),
        _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  bool _initialise = false;

  Future<void> initialiser() async {
    if (_initialise) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _initialise = true;
  }

  /// Analyse les reservations du jour et genere les alertes de check-in
  /// (arrivee aujourd'hui) et check-out (depart aujourd'hui) manquantes.
  Future<List<NotificationAlerte>> genererAlertesDuJour() async {
    await initialiser();

    final maintenant = DateTime.now();
    final aujourdhui = DateTime(maintenant.year, maintenant.month, maintenant.day);
    final reservations = await _reservationRepository.getAll();
    final alertesExistantes = await _notificationRepository.getAll();

    bool dejaAlerte(int reservationId, TypeNotification type) {
      return alertesExistantes.any((a) => a.reservationId == reservationId && a.type == type);
    }

    final nouvellesAlertes = <NotificationAlerte>[];

    for (final reservation in reservations) {
      if (reservation.statut == StatutReservation.annulee) continue;

      final estArriveeAujourdhui = _estMemeJour(reservation.dateArrivee, aujourdhui);
      final estDepartAujourdhui = _estMemeJour(reservation.dateDepart, aujourdhui);

      if (estArriveeAujourdhui &&
          reservation.statut == StatutReservation.enAttente &&
          !dejaAlerte(reservation.id!, TypeNotification.checkIn)) {
        final alerte = NotificationAlerte(
          reservationId: reservation.id!,
          type: TypeNotification.checkIn,
          titre: 'Check-in aujourd\'hui',
          message: 'Un client est attendu aujourd\'hui pour son arrivee (reservation #${reservation.id}).',
          dateAlerte: DateTime.now(),
        );
        final id = await _notificationRepository.create(alerte);
        nouvellesAlertes.add(alerte.copyWith(id: id));
        await _afficherNotificationSysteme(id, alerte);
      }

      if (estDepartAujourdhui &&
          reservation.statut == StatutReservation.confirmee &&
          !dejaAlerte(reservation.id!, TypeNotification.checkOut)) {
        final alerte = NotificationAlerte(
          reservationId: reservation.id!,
          type: TypeNotification.checkOut,
          titre: 'Check-out aujourd\'hui',
          message: 'Un client doit liberer sa chambre aujourd\'hui (reservation #${reservation.id}).',
          dateAlerte: DateTime.now(),
        );
        final id = await _notificationRepository.create(alerte);
        nouvellesAlertes.add(alerte.copyWith(id: id));
        await _afficherNotificationSysteme(id, alerte);
      }
    }

    return nouvellesAlertes;
  }

  Future<void> _afficherNotificationSysteme(int id, NotificationAlerte alerte) async {
    const androidDetails = AndroidNotificationDetails(
      'hotel_smart_checkin_checkout',
      'Check-in / Check-out',
      channelDescription: 'Alertes de check-in et check-out du jour',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    try {
      await _plugin.show(id, alerte.titre, alerte.message, details);
    } catch (_) {
      // Sur certaines plateformes/emulateurs sans support de notifications
      // systeme, l'alerte reste neanmoins persistee en base (point 38 :
      // ne jamais faire planter l'application pour une fonctionnalite
      // secondaire).
    }
  }

  Future<List<NotificationAlerte>> getAlertesNonLues() => _notificationRepository.getUnread();

  Future<void> marquerCommeLue(int id) => _notificationRepository.markAsRead(id);

  bool _estMemeJour(DateTime date, DateTime reference) {
    return date.year == reference.year && date.month == reference.month && date.day == reference.day;
  }
}
