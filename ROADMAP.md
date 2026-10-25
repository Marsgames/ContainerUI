# Roadmap

> This roadmap is a living document — priorities may shift as the project grows and community feedback comes in.

---

## v0.1 — Foundation `[in progress]`

Get the app running and talking to the container runtime. No polish, just working fundamentals.

- [x] Project setup (SwiftUI, Xcode, dark design language)
- [x] Side panel navigation (Containers, Images, Registries, Documentation, Parameters)
- [x] Loading screen with progress indicator
- [x] Missing-components detection and install prompt
- [ ] Connect to Apple's container system runtime via CLI/XPC
- [ ] List running and stopped containers
- [ ] Start / stop / restart a container
- [ ] List local images
- [ ] Basic app preferences (window state persistence)

---

## v0.2 — MVP

The minimum viable product: everything a user needs to replace the command line for day-to-day container work.

- [ ] View container logs (live-streaming)
- [ ] View container details (ports, mounts, environment variables, resource usage)
- [ ] Delete a container (with confirmation)
- [ ] Pull an image from a registry
- [ ] Delete an image (with confirmation)
- [ ] Add / remove a registry (credentials stored in Keychain)
- [ ] Error handling and user-facing error messages throughout

---

## v1.0 — Release

A polished, distributable version of the MVP. Feature-complete for the core use case; ready for public release.

- [ ] App icon and final branding assets
- [ ] Onboarding flow for first-time users
- [ ] Contextual help panels in each section
- [ ] Localisation (English primary, French included)
- [ ] Accessibility audit (VoiceOver, keyboard navigation)
- [ ] Notarisation and Gatekeeper compliance
- [ ] GitHub Release with pre-built `.dmg`
- [ ] Homebrew cask (`brew install --cask containerui`)

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
