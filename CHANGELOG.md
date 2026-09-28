# Journal des modifications

Toutes les modifications notables de ce projet sont documentées dans ce fichier.

Le format suit [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/) et le projet adhère au [versionnage sémantique](https://semver.org/lang/fr/).

## [Unreleased]

## [1.3.0] - 2026-09-28

### Ajouté

- Illustrations locales des trois types de chambres et widget `AppImage` avec
  décodage adapté à la taille, fondu et solution de secours.
- Tests de widgets pour le chargement paresseux des chambres, le secours
  d'image et le libellé sémantique.
- Workflows GitHub Actions pour l'analyse, les tests, la couverture, les tests
  d'intégration Linux, la construction APK et les GitHub Releases.

### Modifié

- Règles d'analyse renforcées et écoute ciblée des providers avec
  `context.select`.
- Listes de données avec construction paresseuse et clés stables ; graphiques
  statistiques isolés par `RepaintBoundary`.
- APK release signé par la clé debug lorsqu'aucun `android/key.properties`
  n'est présent.
- Captures PNG converties en WebP sans perte de pixels et galerie README
  complétée.

## [1.2.0] - 2026-09-28

### Ajouté

- Internationalisation de l’application en français et en anglais.

### Modifié

- Optimisations des performances de l’application.

## [1.1.0] - 2026-09-28

### Ajouté

- Intégration continue et déploiement continu avec GitHub Actions.
- Tests de widgets et tests d’intégration.
- Prise en charge de l’accessibilité avec `Semantics`.

## [1.0.0] - 2026-09-16

### Ajouté

- Version initiale avec trois profils : Admin, Réceptionniste et Client.
- Gestion des chambres, des clients, des réservations et des paiements.
- Tableau de bord et statistiques.
- Thèmes clair et sombre.

[Unreleased]: https://github.com/Aissata-Tounkara/hotel_smart/compare/v1.3.0...HEAD
[1.3.0]: https://github.com/Aissata-Tounkara/hotel_smart/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/Aissata-Tounkara/hotel_smart/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/Aissata-Tounkara/hotel_smart/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Aissata-Tounkara/hotel_smart/releases/tag/v1.0.0
