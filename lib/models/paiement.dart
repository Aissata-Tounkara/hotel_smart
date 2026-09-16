enum StatutPaiement { paye, enAttente, rembourse }

extension StatutPaiementX on StatutPaiement {
  String get valeur => name;

  static StatutPaiement fromValeur(String valeur) {
    return StatutPaiement.values.firstWhere(
      (s) => s.name == valeur,
      orElse: () => StatutPaiement.enAttente,
    );
  }

  String get libelle {
    switch (this) {
      case StatutPaiement.paye:
        return 'Paye';
      case StatutPaiement.enAttente:
        return 'En attente';
      case StatutPaiement.rembourse:
        return 'Rembourse';
    }
  }
}

/// Paiement associe a une [Reservation].
class Paiement {
  final int? id;
  final int reservationId;
  final double montant;
  final StatutPaiement statut;
  final String methode;
  final DateTime datePaiement;

  const Paiement({
    this.id,
    required this.reservationId,
    required this.montant,
    required this.statut,
    required this.methode,
    required this.datePaiement,
  });

  Paiement copyWith({
    int? id,
    int? reservationId,
    double? montant,
    StatutPaiement? statut,
    String? methode,
    DateTime? datePaiement,
  }) {
    return Paiement(
      id: id ?? this.id,
      reservationId: reservationId ?? this.reservationId,
      montant: montant ?? this.montant,
      statut: statut ?? this.statut,
      methode: methode ?? this.methode,
      datePaiement: datePaiement ?? this.datePaiement,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reservation_id': reservationId,
      'montant': montant,
      'statut': statut.valeur,
      'methode': methode,
      'date_paiement': datePaiement.toIso8601String(),
    };
  }

  factory Paiement.fromMap(Map<String, dynamic> map) {
    return Paiement(
      id: map['id'] as int?,
      reservationId: map['reservation_id'] as int,
      montant: (map['montant'] as num).toDouble(),
      statut: StatutPaiementX.fromValeur(map['statut'] as String),
      methode: map['methode'] as String,
      datePaiement: DateTime.parse(map['date_paiement'] as String),
    );
  }
}
