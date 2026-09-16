import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_smart/utils/validators.dart';

void main() {
  group('Validators', () {
    test('email rejette un champ vide (cas limite formulaire vide)', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('email rejette un format invalide et accepte un format valide', () {
      expect(Validators.email('pas-un-email'), isNotNull);
      expect(Validators.email('contact@hotelsmart.dz'), isNull);
    });

    test('phone rejette des caracteres non numeriques', () {
      expect(Validators.phone('abcdefgh'), isNotNull);
      expect(Validators.phone('0555123456'), isNull);
    });

    test('password impose une longueur minimale', () {
      expect(Validators.password('123'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });

    test('positiveNumber rejette zero, negatif et texte non numerique', () {
      expect(Validators.positiveNumber('0'), isNotNull);
      expect(Validators.positiveNumber('-10'), isNotNull);
      expect(Validators.positiveNumber('abc'), isNotNull);
      expect(Validators.positiveNumber('4500'), isNull);
    });
  });
}
