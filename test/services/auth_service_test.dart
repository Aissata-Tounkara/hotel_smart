import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_smart/services/auth_service.dart';

void main() {
  group('AuthService.hashPassword', () {
    final authService = AuthService();

    test('produit toujours le meme hash SHA-256 pour le meme mot de passe', () {
      final hash1 = authService.hashPassword('Admin@123');
      final hash2 = authService.hashPassword('Admin@123');
      expect(hash1, hash2);
    });

    test('produit un hash different pour des mots de passe differents', () {
      final hash1 = authService.hashPassword('Admin@123');
      final hash2 = authService.hashPassword('AutreMotDePasse');
      expect(hash1, isNot(equals(hash2)));
    });

    test('ne stocke jamais le mot de passe en clair dans le hash', () {
      final hash = authService.hashPassword('Admin@123');
      expect(hash.contains('Admin@123'), isFalse);
      expect(hash.length, 64); // SHA-256 = 64 caracteres hexadecimaux
    });
  });
}
