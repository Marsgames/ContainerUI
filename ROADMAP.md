# Roadmap

> This roadmap is a living document — priorities may shift as the project grows and community feedback comes in.

---

## v0.1 — Foundation `[in progress]`

Get the app running and talking to the container runtime. No polish, just working fundamentals.

- [x] Project setup (SwiftUI, Xcode, dark design language)
- [x] Side panel navigation (Containers, Images, Registries, Documentation, Parameters)
- [x] Loading screen with progress indicator
- [x] Missing-components detection and install prompt
- [x] Connect to Apple's container system runtime via CLI/XPC
- [x] List running and stopped containers
- [x] Start / stop / restart a container
- [x] List local images
- [x] Basic app preferences (window state persistence)

---

## v0.2 — MVP `[in progress]`

The minimum viable product: everything a user needs to replace the command line for day-to-day container work.

- [x] View container logs
- [x] View container details (mounts, environment variables, resource usage)
- [x] Delete a container (with confirmation)
- [x] Pull an image from a registry
- [x] Delete an image (with confirmation)
- [x] Add / remove a registry (credentials stored in Keychain)
- [x] Error handling and user-facing error messages throughout

---

## v1.0 — Release `[in progress]`

A polished, distributable version of the MVP. Feature-complete for the core use case; ready for public release.

- [x] App icon and final branding assets
- [x] Onboarding flow for first-time users
- [x] Contextual help panels in each section
- [x] Localisation (English primary, French included)
- [x] Accessibility audit (VoiceOver, keyboard navigation)
- [x] Notarisation and Gatekeeper compliance
- [x] GitHub Release with pre-built `.dmg`
- [x] Homebrew cask (`brew install --cask containerui`)

---

## v1.x — Advanced Features

Post-release improvements, tackled based on community demand.

- [ ] Execute a command inside a running container (shell access)
- [ ] Build an image from a Dockerfile (path picker + build log)
- [ ] Push a local image to a registry
- [ ] Inspect an image (layers, config, history)
- [ ] Browse a registry's available images and tags
- [ ] Menu-bar icon with quick container status
- [ ] System notifications (container crash, image pull complete)
- [ ] Check for app updates (in-app)

---

## Future Ideas

Not scheduled, but worth tracking.

- Compose / multi-container stacks support
- CLI companion tool (`containerui`)
- Plugin / extension system
- Appearance preferences (accent color, font size)
