# Release notes template

This document is used to write user-facing release notes (App Store and TestFlight).

## Rules

- Start with what the user sees or feels.
- 3 to 8 bullet points maximum, one idea per bullet.
- Remove empty sections.
- Avoid file names, class names, endpoints, tickets, or internal terms.
- Internal changes go under **Under the hood**, in a single line.
- App Store Connect displays the field as plain text: keep section titles simple
  and bullets with `-`, do not rely on Markdown rendering.
- For localised versions, adapt the text rather than translating word for word.

Recommended sections:

| Section | Usage |
| --- | --- |
| Version number | ---------- X.X ---------- |
| Build number if applicable |----- X ----- |
| New | Genuinely new feature |
| Improved | UX, performance, visible reliability |
| Fixed | Bugs and crashes |
| Removed | Feature removed (rather than "Deleted") |
| Under the hood | Backend, CI, technical debt — one line max |

## English template

```text
---------- X.X ----------
----- X -----
New:
- ...

Improved:
- ...
- ...

Fixed:
- ...
- ...

Under the hood:
- ...
```

## French template

```text
---------- X.X ----------
----- X -----
Nouveautés :
- ...

Améliorations :
- ...
- ...

Corrections :
- ...
- ...

Sous le capot :
- ...
```

## Example

### English

```text
---------- 1.0 ----------
----- 28 -----
Improved:
- The current card stays in place when new releases arrive.
- Loading more releases is more reliable when only a few cards remain.
- Widgets refresh after each swipe.

Fixed:
- Fixed several potential crashes in settings, calendar, history and trailer links.
- Widgets no longer crash when an image or a date is unavailable.

Under the hood:
- Backend, API and general reliability improvements.

----- 27 -----
Under the hood:
- API changes
```

### French

```text
---------- 1.0 ----------
----- 28 -----
Améliorations :
- La carte affichée reste en place quand de nouvelles sorties arrivent.
- Le chargement de nouvelles sorties est plus fiable quand il reste peu de cartes.
- Les widgets se mettent à jour après chaque swipe.

Corrections :
- Correction de plusieurs crashs possibles dans les réglages, le calendrier,
  l'historique et les liens de bande-annonce.
- Les widgets ne plantent plus si une image ou une date est indisponible.

Sous le capot :
- Améliorations du backend, de l'API et de la fiabilité générale.

----- 27 -----
Sous le capot :
- Changement liés à l'API
```

## Where to copy what

- **App Store Connect → What's New**: copy the visible block only
  (omit "Under the hood" if the technical detail adds nothing for users).
- **TestFlight → What to Test**: reuse the same block, optionally adding
  a note about which screens to focus on.
