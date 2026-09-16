# Documentation technique - Hotel Smart

## 1. Presentation

Hotel Smart est une application mobile Flutter de gestion hoteliere pour
l'hotel *Le Palace* (4 etoiles, Alger). Trois profils utilisateurs :
Admin, Receptionniste, Client.

## 2. Stack technique

| Besoin | Choix | Justification |
|---|---|---|
| Base de donnees locale | `sqflite` | Standard Flutter pour SQLite embarque, pas de dependance reseau |
| API externe | `http` + countries.dev | Peuple la liste des nationalites (point 27), avec liste de secours locale si indisponible |
| Gestion d'etat | `provider` (ChangeNotifier) | Simple, largement adopte, suffisant pour la taille du projet |
| Design | Material Design 3 | Impose par le cahier des charges |
| Hachage mot de passe | `crypto` (SHA-256) | Ne jamais stocker de mot de passe en clair |
| Session | `shared_preferences` | Persistance legere de l'ID utilisateur connecte |
| Notifications | `flutter_local_notifications` | Alertes check-in/check-out locales, sans backend |
| Graphiques | `fl_chart` | Graphiques en barres pour l'ecran Statistiques |
| i18n systeme | `flutter_localizations` | Localise les widgets Material (dates, boutons) et active le RTL en arabe |

## 3. Architecture

Architecture en couches (voir aussi `README.md`) :

```
UI (screens/widgets)
   -> Providers (ChangeNotifier) : etat observable par l'UI
      -> Services : logique metier (peut combiner plusieurs repositories)
         -> Repositories : un par table SQLite, CRUD brut
            -> DatabaseHelper : Singleton, ouverture/creation de la base
```

Cette separation permet de tester les services et les modeles
independamment de l'UI (voir `test/`), et de changer la source de
donnees (ex. passer a une API distante) sans reecrire les ecrans.

### 3.1 Structure des dossiers

```
lib/
├── models/        Utilisateur, Client, Chambre, Reservation, Paiement, NotificationAlerte
├── services/       AuthService, ApiService, ReservationService, StatisticsService, NotificationService
├── repositories/    UserRepository, ClientRepository, RoomRepository, ReservationRepository, PaymentRepository, NotificationRepository
├── providers/      AuthProvider, RoomProvider, ClientProvider, ReservationProvider, PaymentProvider, UserProvider, StatisticsProvider, NotificationProvider, SettingsProvider
├── database/       DatabaseHelper (Singleton SQLite)
├── screens/        auth/, dashboard/, rooms/, reservations/, clients/, users/, payments/, profile/, settings/, statistics/
├── widgets/        StatusBadge, EmptyState, confirm_dialog
├── utils/          app_theme, constants, validators, ui_helpers, app_strings
└── routes/         app_routes.dart (navigation nommee)
```

### 3.2 Decisions de conception

Voir la section "Decisions de conception" du `README.md` (Utilisateur vs
Client, Statistique sans table, notifications persistees, compte Admin
par defaut, theme Material 3).

## 4. Schema de la base de donnees

6 tables SQLite, cles etrangeres actives via `PRAGMA foreign_keys = ON` :

```
users (id, nom, email UNIQUE, mot_de_passe_hache, role, client_id -> clients.id, date_creation)
clients (id, nom, prenom, telephone, email, nationalite, cin, date_creation)
rooms (id, numero UNIQUE, type, prix_par_nuit, statut, description, etage)
reservations (id, client_id -> clients.id, room_id -> rooms.id, date_arrivee, date_depart, statut, montant_total, date_creation)
payments (id, reservation_id -> reservations.id, montant, statut, methode, date_paiement)
notifications (id, reservation_id -> reservations.id, type, titre, message, date_alerte, lue)
```

Suppressions en cascade : supprimer un client ou une chambre supprime les
reservations liees (et donc paiements/notifications liees). Ce choix
simplifie la coherence des donnees pour une application de gestion mono-
etablissement ; il est assume et documente ici plutot que laisse
implicite.

Index crees sur toutes les cles etrangeres et sur les dates de
reservation (`idx_reservations_dates`) pour optimiser les recherches de
conflits de dates (point 39).

## 5. Ecrans principaux

| Ecran | Fichier | Role(s) |
|---|---|---|
| Connexion | `screens/auth/login_screen.dart` | Tous |
| Tableau de bord | `screens/dashboard/dashboard_screen.dart` | Tous (contenu adapte au role) |
| Chambres (liste/carte, filtres, recherche) | `screens/rooms/room_list_screen.dart` | Admin, Receptionniste |
| Formulaire chambre | `screens/rooms/room_form_screen.dart` | Admin, Receptionniste |
| Reservations (filtres, check-in/out) | `screens/reservations/reservation_list_screen.dart` | Admin, Receptionniste |
| Nouvelle reservation | `screens/reservations/reservation_form_screen.dart` | Admin, Receptionniste |
| Mes reservations | `screens/reservations/my_reservations_screen.dart` | Client |
| Clients | `screens/clients/client_list_screen.dart`, `client_form_screen.dart` | Admin, Receptionniste |
| Utilisateurs | `screens/users/user_list_screen.dart`, `user_form_screen.dart` | Admin |
| Paiements | `screens/payments/payment_list_screen.dart`, `payment_form_screen.dart` | Admin, Receptionniste |
| Statistiques (graphiques) | `screens/statistics/statistics_screen.dart` | Admin |
| Profil | `screens/profile/profile_screen.dart` | Tous |
| Parametres | `screens/settings/settings_screen.dart` | Tous |

## 6. Gestion des roles et permissions

`AuthProvider` expose des getters derives du role de l'utilisateur
connecte (`estAdmin`, `estReceptionniste`, `estClient`,
`peutGererOperations`). Les ecrans utilisent ces getters pour :
- Masquer/afficher les boutons d'action (ajout, modification, suppression).
- Restreindre la navigation depuis le tableau de bord.
- Filtrer les donnees visibles (ex. `MyReservationsScreen` ne charge que
  les reservations du `clientId` lie au compte connecte).

## 7. Gestion des erreurs

- **Reseau** (`ApiService`) : `ApiException` dediee en interne, mais
  `getNationalites()` ne la laisse jamais remonter jusqu'a l'UI - en cas
  d'echec (pas de connexion, timeout, erreur serveur, reponse invalide),
  une liste de secours locale de 30 nationalites est utilisee
  automatiquement, avec un message discret (non bloquant) et un bouton
  "Reessayer" pour retenter l'appel reseau. Le formulaire client n'est
  ainsi jamais bloque par une panne du service tiers.
- **Metier** (`AuthException`, `ReservationException`) : messages clairs
  affiches via `SnackBar` plutot que de laisser remonter une erreur brute.
- **Cas limites** : formulaires valides cote client (`Validators`) avant
  tout appel base de donnees ; base vide au premier lancement geree par
  l'insertion automatique d'un compte Admin par defaut.

## 8. Tests

`flutter test` execute les tests unitaires (modeles, services,
validateurs) situes dans `test/`. Voir `test/models/`, `test/services/`,
`test/utils/`.

## 9. Build

```bash
flutter analyze        # 0 warning attendu
flutter test            # tous les tests doivent passer
flutter build apk --release
```
