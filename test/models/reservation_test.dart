import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_smart/models/reservation.dart';

void main() {
  group('Reservation', () {
    test('dureeSejour calcule le nombre de nuits entre arrivee et depart', () {
      final reservation = Reservation(
        clientId: 1,
        chambreId: 1,
        dateArrivee: DateTime(2026, 1, 10),
        dateDepart: DateTime(2026, 1, 15),
        statut: StatutReservation.confirmee,
        montantTotal: 25000,
        dateCreation: DateTime(2026, 1, 1),
      );
      expect(reservation.dureeSejour, 5);
    });

    test('chevauche detecte un conflit de dates qui se recoupent', () {
      final reservation = Reservation(
        clientId: 1,
        chambreId: 1,
        dateArrivee: DateTime(2026, 1, 10),
        dateDepart: DateTime(2026, 1, 15),
        statut: StatutReservation.confirmee,
        montantTotal: 25000,
        dateCreation: DateTime(2026, 1, 1),
      );
      // Une nouvelle demande du 12 au 20 chevauche la reservation existante.
      expect(reservation.chevauche(DateTime(2026, 1, 12), DateTime(2026, 1, 20)), isTrue);
    });

    test('chevauche renvoie false pour des periodes disjointes', () {
      final reservation = Reservation(
        clientId: 1,
        chambreId: 1,
        dateArrivee: DateTime(2026, 1, 10),
        dateDepart: DateTime(2026, 1, 15),
        statut: StatutReservation.confirmee,
        montantTotal: 25000,
        dateCreation: DateTime(2026, 1, 1),
      );
      // Une reservation du 15 au 20 commence exactement au depart de la premiere : pas de conflit.
      expect(reservation.chevauche(DateTime(2026, 1, 15), DateTime(2026, 1, 20)), isFalse);
    });

    test('toMap puis fromMap redonne une reservation equivalente', () {
      final original = Reservation(
        id: 7,
        clientId: 2,
        chambreId: 3,
        dateArrivee: DateTime(2026, 2, 1),
        dateDepart: DateTime(2026, 2, 4),
        statut: StatutReservation.enAttente,
        montantTotal: 15000,
        dateCreation: DateTime(2026, 1, 20),
      );

      final reconstruite = Reservation.fromMap(original.toMap());

      expect(reconstruite.id, original.id);
      expect(reconstruite.clientId, original.clientId);
      expect(reconstruite.chambreId, original.chambreId);
      expect(reconstruite.statut, original.statut);
      expect(reconstruite.montantTotal, original.montantTotal);
    });
  });
}
