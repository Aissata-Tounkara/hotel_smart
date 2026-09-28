import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hotel_smart/database/database_helper.dart';
import 'package:hotel_smart/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final databaseHelper = DatabaseHelper.instance;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await databaseHelper.close();
    databaseHelper.configureForTesting(useInMemoryDatabase: true);
  });

  tearDown(() async {
    await databaseHelper.close();
  });

  tearDownAll(() {
    databaseHelper.configureForTesting(useInMemoryDatabase: false);
  });

  Future<void> seConnecterCommeAdmin(WidgetTester tester) async {
    await tester.pumpWidget(const HotelSmartApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'admin@hotelsmart.dz',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Admin@123');
    await tester.tap(find.text('SE CONNECTER'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  // Démonte l'app pour libérer sémantique, timers et streams
  // avant la fin du test et la fermeture de la base.
  Future<void> demonterApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }

  testWidgets('connexion admin affiche le tableau de bord', (tester) async {
    try {
      await seConnecterCommeAdmin(tester);

      expect(find.text('Tableau de bord'), findsOneWidget);
      expect(find.text('Bienvenue, Administrateur'), findsOneWidget);
    } finally {
      await demonterApp(tester);
    }
  });

  testWidgets('connexion admin permet d’ouvrir la liste des chambres', (
    tester,
  ) async {
    try {
      await seConnecterCommeAdmin(tester);
      await tester.drag(find.byType(ListView).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Chambres'));
      await tester.tap(find.text('Chambres'));
      await tester.pumpAndSettle();

      // "Chambres" peut apparaître dans la navigation ET dans le titre
      expect(find.text('Chambres'), findsWidgets);
      expect(find.text('Aucune chambre trouvée'), findsOneWidget);
    } finally {
      await demonterApp(tester);
    }
  });
}
