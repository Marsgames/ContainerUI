# Feuille de route

Ce document décrit le développement prévu de ContainerUI. Les jalons sont ordonnés par priorité et dépendance ; les éléments au sein d'un même jalon peuvent être traités en parallèle.

> Cette feuille de route est un document vivant — les priorités peuvent évoluer au fur et à mesure que le projet grandit et que les retours de la communauté arrivent.

---

## Jalon 1 — Fondations `[en cours]`

Infrastructure de base et squelette de l'application.

- [x] Mise en place du projet (SwiftUI, Xcode, identité visuelle sombre)
- [x] Navigation latérale (Conteneurs, Images, Registres, Documentation, Paramètres)
- [x] Écran de chargement avec indicateur de progression
- [x] Détection des composants manquants et invite d'installation
- [ ] Connexion au runtime du système de conteneurs Apple via CLI/XPC
- [ ] Persistance de l'état de l'application entre les lancements (section active, taille de fenêtre)

---

## Jalon 2 — Conteneurs

Parcourir et gérer les conteneurs en cours et arrêtés.

- [ ] Lister tous les conteneurs avec nom, image, état et durée de fonctionnement
- [ ] Démarrer / arrêter / redémarrer un conteneur
- [ ] Supprimer un conteneur (avec confirmation)
- [ ] Afficher les logs d'un conteneur (en temps réel)
- [ ] Afficher les détails d'un conteneur (ports, montages, variables d'environnement, ressources)
- [ ] Exécuter une commande dans un conteneur en cours (accès shell)

---

## Jalon 3 — Images

Parcourir et gérer les images locales.

- [ ] Lister toutes les images locales avec nom, tag, taille et date de création
- [ ] Télécharger une image depuis un registre (pull)
- [ ] Supprimer une image (avec confirmation)
- [ ] Inspecter une image (couches, configuration, historique)
- [ ] Construire une image depuis un Dockerfile (sélecteur de chemin + journal de build)

---

## Jalon 4 — Registres

Se connecter à des registres de conteneurs publics et privés.

- [ ] Ajouter / supprimer un registre (URL, identifiants stockés dans le Trousseau)
- [ ] Parcourir les images et tags disponibles sur un registre
- [ ] Pousser une image locale vers un registre (push)
- [ ] Support de Docker Hub, GitHub Container Registry et registres personnalisés

---

## Jalon 5 — Documentation

Documentation intégrée et onboarding.

- [ ] Guide de démarrage rapide intégré pour le système de conteneurs Apple
- [ ] Panneaux d'aide contextuelle dans chaque section
- [ ] Liens vers la documentation officielle Apple et les ressources communautaires

---

## Jalon 6 — Paramètres et préférences

Réglages de l'application et du runtime.

- [ ] Configuration du runtime (limites de ressources, registre par défaut, chemin de stockage)
- [ ] Préférences d'apparence (couleur d'accentuation, taille de police)
- [ ] Vue d'ensemble des raccourcis clavier
- [ ] Vérification des mises à jour de l'application

---

## Jalon 7 — Finitions et distribution

Préparer ContainerUI pour sa sortie publique.

- [ ] Icône de l'application et ressources visuelles
- [ ] Localisation (anglais en principal, français inclus)
- [ ] Audit d'accessibilité (VoiceOver, navigation clavier)
- [ ] Notarisation et conformité Gatekeeper
- [ ] Releases GitHub avec `.dmg` pré-construit
- [ ] Cask Homebrew (`brew install --cask containerui`)

---

## Idées futures

Non planifiées, mais susceptibles d'être intégrées selon la demande :

- Icône dans la barre de menus avec statut rapide des conteneurs
- Support des stacks multi-conteneurs (Compose)
- Notifications système (crash de conteneur, téléchargement d'image terminé)
- Outil CLI compagnon (`containerui`)
- Système de plugins / extensions
