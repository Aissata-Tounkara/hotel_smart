import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_smart/models/chambre.dart';
import 'package:hotel_smart/services/reservation_service.dart';

void main() {
  group('ReservationService.calculerMontantTotal', () {
    final reservationService = ReservationService();

    test('multiplie le prix par nuit par la duree du sejour', () {
      const chambre = Chambre(
        id: 1,
        numero: '101',
        type: TypeChambre.double_,
        prixParNuit: 5000,
        statut: StatutChambre.disponible,
        etage: 1,
      );

      final montant = reservationService.calculerMontantTotal(
        chambre,
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 4),
      );

      expect(montant, 15000); // 5000 DA x 3 nuits
    });

    test('renvoie 0 si arrivee et depart sont le meme jour', () {
      const chambre = Chambre(
        id: 1,
        numero: '102',
        type: TypeChambre.simple,
        prixParNuit: 3000,
        statut: StatutChambre.disponible,
        etage: 1,
      );

      final montant = reservationService.calculerMontantTotal(
        chambre,
        DateTime(2026, 3, 1),
        DateTime(2026, 3, 1),
      );

      expect(montant, 0);
    });
  });
}
