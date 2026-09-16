# Wireframes - Hotel Smart

Description textuelle des ecrans principaux (basse fidelite).

## 1. Connexion (`/login`)

```
┌───────────────────────────────┐
│         [Logo Hotel Smart]     │
│                                 │
│   Email      [______________]  │
│   Mot de passe [____________]  │
│                                 │
│           [ Se connecter ]     │
│                                 │
│   (message d'erreur si echec)  │
└───────────────────────────────┘
```
- Validation des champs (email non vide/format, mot de passe non vide).
- Verification du hash SHA-256 en base via `AuthService`.
- Redirection vers `/dashboard` selon le role (Admin / Receptionniste / Client).

## 2. Tableau de bord (`/dashboard`)

```
┌───────────────────────────────┐
│ AppBar: Hotel Smart   [profil] │
├───────────────────────────────┤
│ [Chambres dispo] [Occupees]    │
│ [Reservations jour] [CA mois]  │
│                                 │
│ Menu (selon role) :            │
│  - Chambres                    │
│  - Reservations                │
│  - Clients                     │
│  - Paiements                   │
│  - Statistiques                │
│  - Utilisateurs (Admin)        │
│  - Mon profil / Mes reservations (Client) │
└───────────────────────────────┘
```
- Le contenu est genere dynamiquement par role via `AuthProvider.role`.

## 3. Liste des chambres (`/rooms`)

```
┌───────────────────────────────┐
│ Recherche [_______] [Filtres▾] │
│ Vue: [Liste] [Carte]   [+ Ajouter] │
├───────────────────────────────┤
│ 🛏 Chambre 101  Simple  Dispo  │
│ 🛏 Chambre 102  Double  Occupee│
│ 🛏 Chambre 103  Suite   Maint. │
└───────────────────────────────┘
```
- Filtres : type, statut, prix. Recherche temps reel par numero/type.
- Bascule ListView / GridView (cartes).

## 4. Reservation (`/reservations/new`)

```
┌───────────────────────────────┐
│ Client: [Rechercher/Selectionner] │
│ Date arrivee: [__/__/____]     │
│ Date depart : [__/__/____]     │
│ Chambres disponibles:          │
│   ( ) 101 Simple  4500 DA/nuit │
│   ( ) 103 Suite  12000 DA/nuit │
│ Montant total : XXXXX DA       │
│           [ Confirmer ]        │
└───────────────────────────────┘
```
- Verification des conflits de dates avant affichage des chambres disponibles.
- Calcul automatique du montant total (prix x duree).

## 5. Profil (`/profile`)

```
┌───────────────────────────────┐
│ Nom     [______________]      │
│ Email   [______________]      │
│ Nouveau mot de passe [______]  │
│ Confirmer mdp        [______]  │
│           [ Enregistrer ]      │
│                                 │
│ Parametres:                    │
│   Theme: (clair/sombre)        │
│   Langue: (FR/AR)              │
│           [ Deconnexion ]      │
└───────────────────────────────┘
```

D'autres ecrans (liste des reservations, clients, paiements, statistiques,
gestion des utilisateurs) suivent le meme gabarit general : AppBar + barre de
recherche/filtre + liste/grille + FAB d'ajout + formulaire modal ou ecran
dedie pour la creation/edition.
