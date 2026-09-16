/// Fiche d'un client de l'hotel (distinct du compte de connexion [Utilisateur]).
class Client {
  final int? id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String nationalite;
  final String? cin;
  final DateTime dateCreation;

  const Client({
    this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.nationalite,
    this.cin,
    required this.dateCreation,
  });

  String get nomComplet => '$prenom $nom';

  Client copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? telephone,
    String? email,
    String? nationalite,
    String? cin,
    DateTime? dateCreation,
  }) {
    return Client(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      nationalite: nationalite ?? this.nationalite,
      cin: cin ?? this.cin,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'nationalite': nationalite,
      'cin': cin,
      'date_creation': dateCreation.toIso8601String(),
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      telephone: map['telephone'] as String,
      email: map['email'] as String,
      nationalite: map['nationalite'] as String,
      cin: map['cin'] as String?,
      dateCreation: DateTime.parse(map['date_creation'] as String),
    );
  }
}
