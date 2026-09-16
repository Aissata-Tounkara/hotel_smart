enum TypeNotification { checkIn, checkOut }

extension TypeNotificationX on TypeNotification {
  String get valeur => name;

  static TypeNotification fromValeur(String valeur) {
    return TypeNotification.values.firstWhere(
      (t) => t.name == valeur,
      orElse: () => TypeNotification.checkIn,
    );
  }

  String get libelle {
    switch (this) {
      case TypeNotification.checkIn:
        return 'Check-in';
      case TypeNotification.checkOut:
        return 'Check-out';
    }
  }
}

/// Alerte locale liee au check-in/check-out d'une [Reservation].
class NotificationAlerte {
  final int? id;
  final int reservationId;
  final TypeNotification type;
  final String titre;
  final String message;
  final DateTime dateAlerte;
  final bool lue;

  const NotificationAlerte({
    this.id,
    required this.reservationId,
    required this.type,
    required this.titre,
    required this.message,
    required this.dateAlerte,
    this.lue = false,
  });

  NotificationAlerte copyWith({
    int? id,
    int? reservationId,
    TypeNotification? type,
    String? titre,
    String? message,
    DateTime? dateAlerte,
    bool? lue,
  }) {
    return NotificationAlerte(
      id: id ?? this.id,
      reservationId: reservationId ?? this.reservationId,
      type: type ?? this.type,
      titre: titre ?? this.titre,
      message: message ?? this.message,
      dateAlerte: dateAlerte ?? this.dateAlerte,
      lue: lue ?? this.lue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reservation_id': reservationId,
      'type': type.valeur,
      'titre': titre,
      'message': message,
      'date_alerte': dateAlerte.toIso8601String(),
      'lue': lue ? 1 : 0,
    };
  }

  factory NotificationAlerte.fromMap(Map<String, dynamic> map) {
    return NotificationAlerte(
      id: map['id'] as int?,
      reservationId: map['reservation_id'] as int,
      type: TypeNotificationX.fromValeur(map['type'] as String),
      titre: map['titre'] as String,
      message: map['message'] as String,
      dateAlerte: DateTime.parse(map['date_alerte'] as String),
      lue: (map['lue'] as int) == 1,
    );
  }
}
