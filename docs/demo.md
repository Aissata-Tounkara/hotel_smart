# Support de demonstration (5 minutes) - Hotel Smart

## 1. Cahier des charges (30s)

Application Flutter de gestion hoteliere pour l'hotel *Le Palace* (Alger,
4 etoiles), avec trois profils : Admin (gestion complete), Receptionniste
(operations quotidiennes) et Client (consultation). Stack imposee :
SQLite (`sqflite`), `provider`, API REST externe, Material Design 3.

## 2. Architecture choisie (45s)

Architecture en couches : `screens` -> `providers` (ChangeNotifier) ->
`services` (logique metier) -> `repositories` (CRUD SQLite) ->
`DatabaseHelper` (Singleton). Point cle a montrer : `Utilisateur` (compte
de connexion) est separe de `Client` (fiche hotel), lies volontairement
par un Admin - jamais automatique.

## 3. Demonstration live (3 min)

1. **Connexion Admin** (`admin@hotelsmart.dz` / `Admin@123`) -> tableau
   de bord avec statistiques dynamiques (chambres disponibles/occupees,
   reservations du jour, CA du mois).
2. **Chambres** : montrer la recherche temps reel, les filtres (type,
   statut, prix), la bascule vue Carte/Liste, puis creer une chambre.
3. **Clients** : creer un client, montrer la liste des nationalites
   chargee depuis `restcountries.com` (et le message d'erreur si le
   reseau est coupe - mode avion).
4. **Reservation** : creer une reservation pour ce client -> montrer la
   detection automatique des chambres disponibles pour les dates
   choisies et le calcul automatique du montant.
5. **Check-in / Check-out** : passer la reservation en check-in (la
   chambre devient "Occupee"), puis check-out (chambre "Disponible").
   Montrer la notification generee (cloche en haut du dashboard).
6. **Paiement** : enregistrer un paiement pour cette reservation.
7. **Statistiques** : graphiques en barres (taux d'occupation par mois,
   revenus par type de chambre).
8. **Utilisateurs** : creer un compte de role Client lie a la fiche
   client creee plus tot -> se deconnecter -> se connecter avec ce
   compte -> montrer que seul "Mes reservations" et "Mon profil" sont
   visibles, et que la liste ne contient que ses propres reservations.
9. **Parametres** : basculer le theme (clair/sombre) et la langue
   (FR/AR) pour montrer le RTL et la traduction des ecrans cles.

## 4. Points forts a mentionner (45s)

- Compte Admin par defaut cree automatiquement (jamais bloque au premier
  lancement).
- Gestion des erreurs reseau explicite (pas de crash silencieux).
- Verification des conflits de dates avant toute reservation.
- Index SQLite sur toutes les cles etrangeres.
- 18 tests unitaires (modeles, services, validateurs) tous passants.
- `flutter analyze` : 0 warning sur l'ensemble du projet.
