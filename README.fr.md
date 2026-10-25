# ContainerUI

> Une application de bureau macOS pour le système de conteneurs natif d'Apple — construite avec SwiftUI.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Plateforme](https://img.shields.io/badge/plateforme-macOS-lightgrey.svg)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-6-orange.svg)](https://swift.org)

---

## Qu'est-ce que ContainerUI ?

ContainerUI est une application de bureau macOS open source qui offre une interface graphique pour gérer des conteneurs via le **système de conteneurs natif d'Apple** (introduit dans macOS 26 Tahoe). Pensez-y comme un Podman Desktop ou Docker Desktop — mais conçu nativement pour macOS avec SwiftUI, dans le respect du langage de design d'Apple tout en y ajoutant sa propre identité visuelle.

L'application vous permet de gérer conteneurs, images et registres de façon claire et intuitive, sans jamais ouvrir un terminal.

## Fonctionnalités (actuelles)

- Interface sombre et minimaliste avec un langage visuel cohérent
- Navigation par panneau latéral : Conteneurs, Images, Registres, Documentation, Paramètres
- Écran de chargement avec progression de l'initialisation
- Invitation à installer les composants manquants

## Captures d'écran

> _Les captures seront ajoutées à mesure que l'interface évolue._

## Prérequis

- macOS 26 Tahoe ou ultérieur
- Mac Apple Silicon (le système de conteneurs natif l'exige)
- Xcode 26+

## Démarrage rapide

```bash
git clone https://github.com/your-org/ContainerUI.git
cd ContainerUI
open ContainerUI.xcodeproj
```

Compilez et lancez le scheme `ContainerUI` dans Xcode.

## Structure du projet

```
ContainerUI/
├── ContainerUI/          # Cible principale
│   ├── ContainerUIApp.swift
│   ├── ContentView.swift
│   ├── SidePanelView.swift
│   ├── HomeView.swift
│   ├── SideButtonWidget.swift
│   └── Extensions/
│       └── Color+Extension.swift
├── Wireframes/           # Références design
└── ContainerUI.xcodeproj/
```

## Philosophie de design

ContainerUI adopte un design **dark-first** : fonds charbon profond (`#1D1D1D`), accents verts pour les états actifs et la progression, accents oranges pour les compteurs et les mises en valeur. L'objectif est une expérience concentrée et sans distraction, qui s'intègre naturellement à macOS sans copier le style système clair standard.

## Feuille de route

Voir [ROADMAP.fr.md](ROADMAP.fr.md) pour les fonctionnalités prévues et les jalons.

## Contribuer

Les contributions sont les bienvenues ! Ouvrez d'abord une issue pour discuter de votre idée avant de soumettre une pull request. Il n'y a pas encore de guide de contribution formel — il sera ajouté au fil du développement.

## Licence

MIT — voir [LICENSE](LICENSE) pour les détails.
