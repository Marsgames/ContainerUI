# Modèle de notes de version

Ce document sert à rédiger les notes destinées aux utilisateurs (App Store et
TestFlight).

## Règles

- Commencer par ce que l'utilisateur voit ou ressent.
- 3 à 8 puces maximum, une idée par puce.
- Supprimer les sections vides.
- Éviter les noms de fichiers, classes, endpoints, tickets ou termes AWS.
- Les changements internes vont dans **Sous le capot**, en une seule ligne.
- App Store Connect affiche le champ en texte brut : garder des titres simples
  et des puces avec `-`, sans compter sur le rendu Markdown.
- Pour les versions localisées, adapter le texte plutôt que de le traduire mot
  pour mot.

Sections recommandées :

| Section | Usage |
| --- | --- |
| Nouveautés / New | Fonctionnalité réellement nouvelle |
| Améliorations / Improved | UX, performance, fiabilité visible |
| Corrections / Fixed | Bugs et crashs corrigés |
| Suppressions / Removed | Fonctionnalité retirée (plutôt que « Deleted ») |
| Sous le capot / Under the hood | Backend, AWS, CI, dette technique — une ligne max |

## Modèle français

```text
Nouveautés
- ...

Améliorations
- ...
- ...

Corrections
- ...
- ...

Sous le capot
- Améliorations techniques et de fiabilité.
```

## English template

```text
New
- ...

Improved
- ...
- ...

Fixed
- ...
- ...

Under the hood
- Technical and reliability improvements.
```

## Exemple 

### Français

```text
Améliorations
- La carte affichée reste en place quand de nouvelles sorties arrivent.
- Le chargement de nouvelles sorties est plus fiable quand il reste peu de cartes.
- Les widgets se mettent à jour après chaque swipe.

Corrections
- Correction de plusieurs crashs possibles dans les réglages, le calendrier,
  l'historique et les liens de bande-annonce.
- Les widgets ne plantent plus si une image ou une date est indisponible.

Sous le capot
- Améliorations du backend, de l'API et de la fiabilité générale.
```

### English

```text
Improved
- The current card stays in place when new releases arrive.
- Loading more releases is more reliable when only a few cards remain.
- Widgets refresh after each swipe.

Fixed
- Fixed several potential crashes in settings, calendar, history and trailer links.
- Widgets no longer crash when an image or a date is unavailable.

Under the hood
- Backend, API and general reliability improvements.
```

## Où copier quoi

- **App Store Connect → What's New** : copier uniquement le bloc visible
  (hors « Sous le capot » si le détail technique n'apporte rien).
- **TestFlight → What to Test** : reprendre le même bloc, avec éventuellement
  une précision sur les écrans à tester.
