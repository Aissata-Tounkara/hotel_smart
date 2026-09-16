/// Role d'un compte de connexion.
enum RoleUtilisateur { admin, receptionniste, client }

extension RoleUtilisateurX on RoleUtilisateur {
  String get valeur => name;

  static RoleUtilisateur fromValeur(String valeur) {
    return RoleUtilisateur.values.firstWhere(
      (r) => r.name == valeur,
      orElse: () => RoleUtilisateur.client,
    );
  }

  String get libelle {
    switch (this) {
      case RoleUtilisateur.admin:
        return 'Administrateur';
      case RoleUtilisateur.receptionniste:
        return 'Receptionniste';
      case RoleUtilisateur.client:
        return 'Client';
    }
  }
}

/// Compte de connexion a l'application (distinct de la fiche [Client]).
///
/// Un [Utilisateur] peut etre lie a une fiche [Client] via [clientId], mais
/// cette liaison n'est jamais automatique : elle est etablie manuellement
/// par l'Admin depuis l'ecran de gestion des utilisateurs.
class Utilisateur {
  final int? id;
  final String nom;
  final String email;
  final String motDePasseHache;
  final RoleUtilisateur role;
  final int? clientId;
  final DateTime dateCreation;

  const Utilisateur({
    this.id,
    required this.nom,
    required this.email,
    required this.motDePasseHache,
    required this.role,
    this.clientId,
    required this.dateCreation,
  });

  Utilisateur copyWith({
    int? id,
    String? nom,
    String? email,
    String? motDePasseHache,
    RoleUtilisateur? role,
    int? clientId,
    bool clearClientId = false,
    DateTime? dateCreation,
  }) {
    return Utilisateur(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      motDePasseHache: motDePasseHache ?? this.motDePasseHache,
      role: role ?? this.role,
      clientId: clearClientId ? null : (clientId ?? this.clientId),
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'mot_de_passe_hache': motDePasseHache,
      'role': role.valeur,
      'client_id': clientId,
      'date_creation': dateCreation.toIso8601String(),
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      email: map['email'] as String,
      motDePasseHache: map['mot_de_passe_hache'] as String,
      role: RoleUtilisateurX.fromValeur(map['role'] as String),
      clientId: map['client_id'] as int?,
      dateCreation: DateTime.parse(map['date_creation'] as String),
    );
  }
}
