import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_smart/models/chambre.dart';
import 'package:hotel_smart/widgets/app_image.dart';
import 'package:hotel_smart/widgets/lazy_room_list.dart';

void main() {
  testWidgets('AppImage montre le secours si son asset est absent', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppImage(
            assetName: 'assets/images/absent.webp',
            semanticLabel: 'Image de chambre',
            width: 120,
            height: 80,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
  });

  testWidgets('AppImage expose son libellé sémantique', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppImage(
              assetName: 'assets/images/rooms/simple.webp',
              semanticLabel: 'Chambre simple',
              width: 120,
              height: 80,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Chambre simple'), findsOneWidget);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets(
    'la liste de 200 chambres ne construit que les éléments visibles',
    (tester) async {
      var construit = 0;
      final rooms = List.generate(
        200,
        (index) => Chambre(
          id: index,
          numero: '$index',
          type: TypeChambre.simple,
          prixParNuit: 100,
          statut: StatutChambre.disponible,
          etage: 1,
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LazyRoomList(
              rooms: rooms,
              itemBuilder: (context, room) {
                construit++;
                return SizedBox(height: 48, child: Text(room.numero));
              },
            ),
          ),
        ),
      );

      expect(construit, lessThan(30));
      expect(construit, lessThan(rooms.length ~/ 4));
    },
  );
}
