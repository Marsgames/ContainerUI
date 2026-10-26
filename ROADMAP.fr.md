# Feuille de route

> Cette feuille de route est un document vivant — les priorités peuvent évoluer au fur et à mesure que le projet grandit et que les retours de la communauté arrivent.

---

## v0.1 — Fondations ✓

Faire fonctionner l'application et la connecter au runtime de conteneurs. Pas de finitions, juste les bases qui marchent.

- [x] Mise en place du projet (SwiftUI, Xcode, identité visuelle sombre)
- [x] Navigation latérale (Conteneurs, Images, Registres, Documentation, Paramètres)
- [x] Écran de chargement avec indicateur de progression
- [x] Détection des composants manquants et invite d'installation
- [x] Connexion au runtime du système de conteneurs Apple via CLI
- [x] Lister les conteneurs en cours et arrêtés
- [x] Démarrer / arrêter / redémarrer un conteneur
- [x] Lister les images locales
- [x] Préférences de base (persistance de l'état de la fenêtre)

---

## v0.2 — MVP ✓

Le produit minimum viable : tout ce dont un utilisateur a besoin pour remplacer la ligne de commande au quotidien.

- [x] Afficher les logs d'un conteneur
- [x] Afficher les détails d'un conteneur (montages, variables d'environnement, ressources)
- [x] Supprimer un conteneur (avec confirmation)
- [x] Télécharger une image depuis un registre (pull)
- [x] Supprimer une image (avec confirmation)
- [x] Ajouter / supprimer un registre (identifiants stockés dans le Trousseau)
- [x] Gestion des erreurs et messages d'erreur affichés à l'utilisateur

---

## v1.0 — Release ✓

Une version polie et distribuable du MVP. Fonctionnellement complète pour le cas d'usage principal ; prête pour la sortie publique.

- [x] Icône de l'application et ressources visuelles finales
- [x] Flux d'onboarding pour les nouveaux utilisateurs
- [x] Panneaux d'aide contextuelle dans chaque section
- [x] Localisation (anglais en principal, français inclus)
- [x] Audit d'accessibilité (VoiceOver, navigation clavier)
- [x] Notarisation et conformité Gatekeeper
- [x] Release GitHub avec `.dmg` pré-construit
- [x] Cask Homebrew (`brew install --cask containerui`)

---

## v1.x — Fonctionnalités avancées

Améliorations post-release, selon les retours de la communauté.

**Conteneurs**
- [ ] Lancer un nouveau conteneur depuis une image — GUI pour `container run` (nom, ports, volumes, variables d'env)
- [ ] Monitoring des ressources en temps réel par conteneur (CPU, mémoire)
- [ ] Exécuter une commande dans un conteneur en cours (accès shell)
- [ ] Renommer un conteneur
- [ ] Exporter / importer un conteneur (`save` / `load`)
- [ ] Filtrage des logs et recherche texte

**Images**
- [ ] Construire une image depuis un Dockerfile (sélecteur de chemin + journal de build en direct)
- [ ] Pousser une image locale vers un registre (push)
- [ ] Inspecter une image (couches, configuration, historique)
- [ ] Tagger une image localement
- [ ] Nettoyer les images inutilisées avec aperçu de l'espace libéré

**Volumes**
- [ ] Liste des volumes (créer, supprimer, inspecter)
- [ ] Statistiques d'utilisation disque par volume

**Registres**
- [ ] Parcourir les images et tags disponibles sur un registre

**macOS**
- [ ] Icône dans la barre de menus avec statut rapide et actions (démarrer/arrêter)
- [ ] Notifications système (crash de conteneur, téléchargement terminé)
- [ ] Vérification des mises à jour de l'application (intégrée)

---

## v2.x — Intégrations et fonctionnalités avancées

Intégration macOS approfondie et outils pour utilisateurs avancés.

- [ ] Support de Shortcuts.app (démarrer/arrêter des conteneurs depuis des automatisations)
- [ ] Intégration Spotlight (rechercher des conteneurs et images depuis ⌘Espace)
- [ ] Gestion des réseaux (créer, supprimer, lister les conteneurs attachés)
- [ ] Visualisation des ports exposés par conteneur
- [ ] Export d'un conteneur en Dockerfile / snippet compose
- [ ] Préférences : intervalle d'auto-refresh, registre par défaut, raccourcis clavier
- [ ] Thème de couleur d'accentuation (vert, bleu, orange…)
- [ ] Support multi-fenêtres

---

## Idées futures

Non planifiées, mais à garder en tête.

- Support des stacks multi-conteneurs (Compose)
- Éditeur de Dockerfile intégré avec lint et coloration syntaxique
- Scan de vulnérabilités des images
- Système de plugins / extensions
- Outil CLI compagnon (`containerui`)
