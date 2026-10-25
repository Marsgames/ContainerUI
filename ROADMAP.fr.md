# Feuille de route

> Cette feuille de route est un document vivant — les priorités peuvent évoluer au fur et à mesure que le projet grandit et que les retours de la communauté arrivent.

---

## v0.1 — Fondations `[en cours]`

Faire fonctionner l'application et la connecter au runtime de conteneurs. Pas de finitions, juste les bases qui marchent.

- [x] Mise en place du projet (SwiftUI, Xcode, identité visuelle sombre)
- [x] Navigation latérale (Conteneurs, Images, Registres, Documentation, Paramètres)
- [x] Écran de chargement avec indicateur de progression
- [x] Détection des composants manquants et invite d'installation
- [x] Connexion au runtime du système de conteneurs Apple via CLI/XPC
- [x] Lister les conteneurs en cours et arrêtés
- [x] Démarrer / arrêter / redémarrer un conteneur
- [x] Lister les images locales
- [x] Préférences de base (persistance de l'état de la fenêtre)

---

## v0.2 — MVP `[en cours]`

Le produit minimum viable : tout ce dont un utilisateur a besoin pour remplacer la ligne de commande au quotidien.

- [x] Afficher les logs d'un conteneur
- [x] Afficher les détails d'un conteneur (montages, variables d'environnement, ressources)
- [x] Supprimer un conteneur (avec confirmation)
- [x] Télécharger une image depuis un registre (pull)
- [x] Supprimer une image (avec confirmation)
- [x] Ajouter / supprimer un registre (identifiants stockés dans le Trousseau)
- [x] Gestion des erreurs et messages d'erreur affichés à l'utilisateur

---

## v1.0 — Release

Une version polie et distribuable du MVP. Fonctionnellement complète pour le cas d'usage principal ; prête pour la sortie publique.

- [ ] Icône de l'application et ressources visuelles finales
- [ ] Flux d'onboarding pour les nouveaux utilisateurs
- [ ] Panneaux d'aide contextuelle dans chaque section
- [ ] Localisation (anglais en principal, français inclus)
- [ ] Audit d'accessibilité (VoiceOver, navigation clavier)
- [ ] Notarisation et conformité Gatekeeper
- [ ] Release GitHub avec `.dmg` pré-construit
- [ ] Cask Homebrew (`brew install --cask containerui`)

---

## v1.x — Fonctionnalités avancées

Améliorations post-release, selon les retours de la communauté.

- [ ] Exécuter une commande dans un conteneur en cours (accès shell)
- [ ] Construire une image depuis un Dockerfile (sélecteur de chemin + journal de build)
- [ ] Pousser une image locale vers un registre (push)
- [ ] Inspecter une image (couches, configuration, historique)
- [ ] Parcourir les images et tags disponibles sur un registre
- [ ] Icône dans la barre de menus avec statut rapide des conteneurs
- [ ] Notifications système (crash de conteneur, téléchargement terminé)
- [ ] Vérification des mises à jour de l'application (intégrée)

---

## Idées futures

Non planifiées, mais à garder en tête.

- Support des stacks multi-conteneurs (Compose)
- Outil CLI compagnon (`containerui`)
- Système de plugins / extensions
- Préférences d'apparence (couleur d'accentuation, taille de police)
