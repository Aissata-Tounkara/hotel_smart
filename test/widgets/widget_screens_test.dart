import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_smart/l10n/app_localizations.dart';
import 'package:hotel_smart/models/chambre.dart';
import 'package:hotel_smart/providers/auth_provider.dart';
import 'package:hotel_smart/providers/room_provider.dart';
import 'package:hotel_smart/providers/settings_provider.dart';
import 'package:hotel_smart/repositories/room_repository.dart';
import 'package:hotel_smart/screens/auth/login_screen.dart';
import 'package:hotel_smart/screens/rooms/room_list_screen.dart';
import 'package:hotel_smart/screens/settings/settings_screen.dart';
import 'package:hotel_smart/widgets/app_text_field.dart';
import 'package:hotel_smart/widgets/premium_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _EmptyRoomRepository extends RoomRepository {
  @override
  Future<List<Chambre>> getAll() async => [];
}

void main() {
  testWidgets('le formulaire de connexion valide les champs vides', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('SE CONNECTER'));
    await tester.tap(find.text('SE CONNECTER'));
    await tester.pumpAndSettle();

    expect(find.text("L'email est obligatoire"), findsOneWidget);
    expect(find.text('Le mot de passe est obligatoire'), findsOneWidget);
  });

  testWidgets('la liste des chambres affiche son etat vide', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => RoomProvider(roomRepository: _EmptyRoomRepository()),
          ),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const RoomListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aucune chambre trouvée'), findsOneWidget);
  });

  testWidgets('AppTextField affiche son label et son message erreur', (
    tester,
  ) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Nom complet',
                  validator: (_) => 'Ce champ est invalide',
                ),
                ElevatedButton(
                  onPressed: () => formKey.currentState!.validate(),
                  child: const Text('Valider'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Nom complet'), findsOneWidget);
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();
    expect(find.text('Ce champ est invalide'), findsOneWidget);
  });

  testWidgets('les parametres changent le theme quand on choisit Sombre', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => SettingsProvider(),
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        ),
      ),
    );

    await tester.tap(find.text('Sombre'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<SegmentedButton<ThemeMode>>(
            find.byType(SegmentedButton<ThemeMode>),
          )
          .selected,
      {ThemeMode.dark},
    );
  });

  testWidgets('PremiumListTile affiche son titre et son sous-titre', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PremiumListTile(
            icon: Icons.hotel,
            title: 'Chambre 204',
            subtitle: 'Suite · disponible',
          ),
        ),
      ),
    );

    expect(find.text('Chambre 204'), findsOneWidget);
    expect(find.text('Suite · disponible'), findsOneWidget);
  });
}
