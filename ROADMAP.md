# Roadmap

> This roadmap is a living document — priorities may shift as the project grows and community feedback comes in.

---

## v0.1 — Foundation ✓

Get the app running and talking to the container runtime. No polish, just working fundamentals.

- [x] Project setup (SwiftUI, Xcode, dark design language)
- [x] Side panel navigation (Containers, Images, Registries, Documentation, Parameters)
- [x] Loading screen with progress indicator
- [x] Missing-components detection and install prompt
- [x] Connect to Apple's container system runtime via CLI
- [x] List running and stopped containers
- [x] Start / stop / restart a container
- [x] List local images
- [x] Basic app preferences (window state persistence)

---

## v0.2 — MVP ✓

The minimum viable product: everything a user needs to replace the command line for day-to-day container work.

- [x] View container logs
- [x] View container details (mounts, environment variables, resource usage)
- [x] Delete a container (with confirmation)
- [x] Pull an image from a registry
- [x] Delete an image (with confirmation)
- [x] Add / remove a registry (credentials stored in Keychain)
- [x] Error handling and user-facing error messages throughout

---

## v1.0 — Release ✓

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

**Containers**
- [ ] Run a new container from an image — GUI for `container run` (name, ports, volumes, environment variables)
- [ ] Real-time resource monitoring per container (CPU usage, memory)
- [ ] Execute a command inside a running container (shell access)
- [ ] Rename a container
- [ ] Export / import a container (`save` / `load`)
- [ ] Log filtering and text search

**Images**
- [ ] Build an image from a Dockerfile (path picker + live build log)
- [ ] Push a local image to a registry
- [ ] Inspect an image (layers, config, history)
- [ ] Tag an image locally
- [ ] Prune unused images with disk-space preview

**Volumes**
- [ ] Volume list (create, delete, inspect)
- [ ] Per-volume disk usage statistics

**Registries**
- [ ] Browse available images and tags on a registry

**macOS**
- [ ] Menu-bar icon with quick container status and start/stop actions
- [ ] System notifications (container crash, pull complete)
- [ ] Check for app updates (in-app)

---

## v2.x — Integrations & Power Features

Deeper macOS integration and power-user tooling.

- [ ] Shortcuts.app support (start/stop containers from automations)
- [ ] Spotlight integration (search containers and images from ⌘Space)
- [ ] Network management (create, delete, list attached containers)
- [ ] Port mapping visualisation per container
- [ ] Container export to Dockerfile / compose snippet
- [ ] Preferences: auto-refresh interval, default registry, keyboard shortcuts
- [ ] Accent colour theme (green, blue, orange…)
- [ ] Multi-window support

---

## Future Ideas

Not scheduled, but worth tracking.

- Compose / multi-container stacks support
- Dockerfile editor with lint and syntax highlighting
- Image vulnerability scanning
- Plugin / extension system
- CLI companion tool (`containerui`)
