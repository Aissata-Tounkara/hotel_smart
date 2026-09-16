# Hotel Smart

Application mobile Flutter de gestion hoteliere pour l'hotel **Le Palace**
(4 etoiles, Alger). Trois profils : Admin, Receptionniste, Client.

## Stack technique

- Flutter / Dart (SDK stable)
- Base de donnees locale : SQLite (`sqflite`)
- API REST externe : `https://restcountries.com/v3.1/all` (nationalites) via `http`
- Gestion d'etat : `provider` (ChangeNotifier)
- Design : Material Design 3
- Autres : `path`, `shared_preferences`, `flutter_spinkit`, `intl`, `crypto`,
  `flutter_local_notifications`, `fl_chart`

## Architecture

Architecture en couches, inspiree du pattern Repository, pour separer
clairement l'UI, l'etat et l'acces aux donnees :

```
UI (screens/widgets)
   ↓ ecoute / declenche des actions
Providers (ChangeNotifier) — etat global de l'application
   ↓ appelle
Services — logique metier (authentification, statistiques, API externe, notifications)
   ↓ appelle
Repositories — une classe par table SQLite, seule couche qui parle a la base
   ↓ utilise
DatabaseHelper (Singleton) — ouverture/creation de la base SQLite
```

- **models/** : classes de donnees pures (`toMap`/`fromMap`), aucune logique metier.
- **repositories/** : CRUD SQLite brut (`UserRepository`, `RoomRepository`,
  `ClientRepository`, `ReservationRepository`, `PaymentRepository`,
  `NotificationRepository`). Aucune regle metier ici, juste des requêtes.
- **services/** : regles metier qui peuvent combiner plusieurs repositories
  (`AuthService` pour le hash + la session, `StatisticsService` pour les
  agregations du dashboard, `ApiService` pour l'appel REST des nationalites,
  `NotificationService` pour les notifications locales).
- **providers/** : etat observable par l'UI via `provider` (`AuthProvider`,
  `RoomProvider`, `ReservationProvider`, `ClientProvider`, `PaymentProvider`,
  `SettingsProvider`).
- **routes/** : navigation nommee centralisee (`app_routes.dart`).
- **utils/** : theme, validateurs, constantes, helpers partages.

### Decisions de conception

- **`Utilisateur` != `Client`** : `Utilisateur` est un compte de connexion
  (email, mot de passe hache, role). `Client` est la fiche d'un client de
  l'hotel (nom, telephone, nationalite). Un `Utilisateur` peut etre lie a un
  `Client` via `clientId` (nullable), mais cette liaison est toujours
  manuelle : c'est l'Admin qui cree un compte Client depuis l'ecran de
  gestion des utilisateurs, en le rattachant a une fiche client deja creee
  par le receptionniste.
- **`Statistique` n'est pas une table** : classe de calcul (`services/statistics_service.dart`)
  qui agrege a la volee les donnees de `reservations`, `payments` et `rooms`.
- **`notifications`** est bien une table SQLite : elle stocke les alertes
  locales de check-in/check-out generees pour le personnel.
- **Schema SQLite** : 5 tables + notifications -> `users`, `rooms`, `clients`,
  `reservations`, `payments`, `notifications`, avec cles etrangeres
  (`reservations.client_id`, `reservations.room_id`,
  `payments.reservation_id`, `notifications.reservation_id`,
  `users.client_id`).
- **Compte Admin par defaut** : a la creation de la base, un compte
  `admin@hotelsmart.dz` (mot de passe hache en SHA-256) est insere
  automatiquement pour ne jamais bloquer l'acces a l'application.
- **Theme Material 3** : bleu nuit `#0D1B2A` (primaire) et or `#D4AF37`
  (accent), declines en variantes claire et sombre.

## Documentation

- [`docs/diagramme_cas_utilisation.puml`](docs/diagramme_cas_utilisation.puml) — diagramme de cas d'utilisation (PlantUML).
- [`docs/diagramme_classes.puml`](docs/diagramme_classes.puml) — diagramme de classes (PlantUML).
- [`docs/wireframes.md`](docs/wireframes.md) — wireframes des ecrans principaux.
- [`docs/documentation_technique.md`](docs/documentation_technique.md) — documentation technique (Jour 3).
- [`docs/manuel_utilisateur.md`](docs/manuel_utilisateur.md) — manuel utilisateur (Jour 3).
- [`docs/demo.md`](docs/demo.md) — support de demonstration (Jour 3).

## Lancer le projet

```bash
flutter pub get
flutter run
```

Au premier lancement, la base SQLite est creee automatiquement avec un
compte Admin par defaut :

- email : `admin@hotelsmart.dz`
- mot de passe : `Admin@123`

## Tests

```bash
flutter test
```
