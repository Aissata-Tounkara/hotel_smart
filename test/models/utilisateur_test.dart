import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_smart/models/utilisateur.dart';

void main() {
  group('Utilisateur', () {
    test('toMap puis fromMap conserve le role et l\'email', () {
      final utilisateur = Utilisateur(
        id: 1,
        nom: 'Amine Kherbache',
        email: 'amine@hotelsmart.dz',
        motDePasseHache: 'hash-test',
        role: RoleUtilisateur.receptionniste,
        clientId: null,
        dateCreation: DateTime(2026, 1, 1),
      );

      final reconstruit = Utilisateur.fromMap(utilisateur.toMap());

      expect(reconstruit.email, utilisateur.email);
      expect(reconstruit.role, RoleUtilisateur.receptionniste);
      expect(reconstruit.clientId, isNull);
    });

    test('copyWith(clearClientId: true) supprime bien le lien client', () {
      final utilisateur = Utilisateur(
        id: 1,
        nom: 'Client Test',
        email: 'client@hotelsmart.dz',
        motDePasseHache: 'hash-test',
        role: RoleUtilisateur.client,
        clientId: 42,
        dateCreation: DateTime(2026, 1, 1),
      );

      final sansClient = utilisateur.copyWith(clearClientId: true);

      expect(sansClient.clientId, isNull);
    });
  });
}
