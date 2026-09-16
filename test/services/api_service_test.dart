import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:hotel_smart/services/api_service.dart';

void main() {
  group('ApiService.getNationalites', () {
    test('renvoie les nationalites de l\'API quand la reponse est valide', () async {
      final client = MockClient((request) async {
        return http.Response('[{"name":"France"},{"name":"Algeria"}]', 200);
      });
      final apiService = ApiService(client: client);

      final resultat = await apiService.getNationalites();

      expect(resultat.depuisListeDeSecours, isFalse);
      expect(resultat.nationalites, containsAll(['France', 'Algeria']));
    });

    test('retombe sur la liste de secours si le serveur repond en erreur', () async {
      final client = MockClient((request) async => http.Response('erreur', 500));
      final apiService = ApiService(client: client);

      final resultat = await apiService.getNationalites();

      expect(resultat.depuisListeDeSecours, isTrue);
      expect(resultat.nationalites, isNotEmpty);
      expect(resultat.nationalites, contains('Algeria'));
    });

    test('retombe sur la liste de secours en cas d\'exception reseau (pas de connexion)', () async {
      final client = MockClient((request) async => throw Exception('Pas de reseau'));
      final apiService = ApiService(client: client);

      final resultat = await apiService.getNationalites();

      expect(resultat.depuisListeDeSecours, isTrue);
      expect(resultat.nationalites, isNotEmpty);
    });
  });
}
