enum StatutReservation { enAttente, confirmee, annulee, terminee }

extension StatutReservationX on StatutReservation {
  String get valeur => name;

  static StatutReservation fromValeur(String valeur) {
    return StatutReservation.values.firstWhere(
      (s) => s.name == valeur,
      orElse: () => StatutReservation.enAttente,
    );
  }

  String get libelle {
    switch (this) {
      case StatutReservation.enAttente:
        return 'En attente';
      case StatutReservation.confirmee:
        return 'Confirmee';
      case StatutReservation.annulee:
        return 'Annulee';
      case StatutReservation.terminee:
        return 'Terminee';
    }
  }
}

/// Reservation d'une [Chambre] par un [Client] pour une periode donnee.
class Reservation {
  final int? id;
  final int clientId;
  final int chambreId;
  final DateTime dateArrivee;
  final DateTime dateDepart;
  final StatutReservation statut;
  final double montantTotal;
  final DateTime dateCreation;

  const Reservation({
    this.id,
    required this.clientId,
    required this.chambreId,
    required this.dateArrivee,
    required this.dateDepart,
    required this.statut,
    required this.montantTotal,
    required this.dateCreation,
  });

  /// Duree du sejour en nombre de nuits.
  int get dureeSejour => dateDepart.difference(dateArrivee).inDays;

  /// Deux periodes se chevauchent si l'une commence avant que l'autre finisse.
  bool chevauche(DateTime debut, DateTime fin) {
    return dateArrivee.isBefore(fin) && debut.isBefore(dateDepart);
  }

  Reservation copyWith({
    int? id,
    int? clientId,
    int? chambreId,
    DateTime? dateArrivee,
    DateTime? dateDepart,
    StatutReservation? statut,
    double? montantTotal,
    DateTime? dateCreation,
  }) {
    return Reservation(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      chambreId: chambreId ?? this.chambreId,
      dateArrivee: dateArrivee ?? this.dateArrivee,
      dateDepart: dateDepart ?? this.dateDepart,
      statut: statut ?? this.statut,
      montantTotal: montantTotal ?? this.montantTotal,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': clientId,
      'room_id': chambreId,
      'date_arrivee': dateArrivee.toIso8601String(),
      'date_depart': dateDepart.toIso8601String(),
      'statut': statut.valeur,
      'montant_total': montantTotal,
      'date_creation': dateCreation.toIso8601String(),
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] as int?,
      clientId: map['client_id'] as int,
      chambreId: map['room_id'] as int,
      dateArrivee: DateTime.parse(map['date_arrivee'] as String),
      dateDepart: DateTime.parse(map['date_depart'] as String),
      statut: StatutReservationX.fromValeur(map['statut'] as String),
      montantTotal: (map['montant_total'] as num).toDouble(),
      dateCreation: DateTime.parse(map['date_creation'] as String),
    );
  }
}
