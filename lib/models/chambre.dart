enum TypeChambre { simple, double_, suite }

extension TypeChambreX on TypeChambre {
  String get valeur => name;

  static TypeChambre fromValeur(String valeur) {
    return TypeChambre.values.firstWhere(
      (t) => t.name == valeur,
      orElse: () => TypeChambre.simple,
    );
  }

  String get libelle {
    switch (this) {
      case TypeChambre.simple:
        return 'Simple';
      case TypeChambre.double_:
        return 'Double';
      case TypeChambre.suite:
        return 'Suite';
    }
  }
}

enum StatutChambre { disponible, occupee, maintenance }

extension StatutChambreX on StatutChambre {
  String get valeur => name;

  static StatutChambre fromValeur(String valeur) {
    return StatutChambre.values.firstWhere(
      (s) => s.name == valeur,
      orElse: () => StatutChambre.disponible,
    );
  }

  String get libelle {
    switch (this) {
      case StatutChambre.disponible:
        return 'Disponible';
      case StatutChambre.occupee:
        return 'Occupee';
      case StatutChambre.maintenance:
        return 'Maintenance';
    }
  }
}

/// Chambre de l'hotel.
class Chambre {
  final int? id;
  final String numero;
  final TypeChambre type;
  final double prixParNuit;
  final StatutChambre statut;
  final String? description;
  final int etage;

  const Chambre({
    this.id,
    required this.numero,
    required this.type,
    required this.prixParNuit,
    required this.statut,
    this.description,
    required this.etage,
  });

  Chambre copyWith({
    int? id,
    String? numero,
    TypeChambre? type,
    double? prixParNuit,
    StatutChambre? statut,
    String? description,
    int? etage,
  }) {
    return Chambre(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      type: type ?? this.type,
      prixParNuit: prixParNuit ?? this.prixParNuit,
      statut: statut ?? this.statut,
      description: description ?? this.description,
      etage: etage ?? this.etage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'type': type.valeur,
      'prix_par_nuit': prixParNuit,
      'statut': statut.valeur,
      'description': description,
      'etage': etage,
    };
  }

  factory Chambre.fromMap(Map<String, dynamic> map) {
    return Chambre(
      id: map['id'] as int?,
      numero: map['numero'] as String,
      type: TypeChambreX.fromValeur(map['type'] as String),
      prixParNuit: (map['prix_par_nuit'] as num).toDouble(),
      statut: StatutChambreX.fromValeur(map['statut'] as String),
      description: map['description'] as String?,
      etage: map['etage'] as int,
    );
  }
}
