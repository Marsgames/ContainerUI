# Roadmap

This document outlines the planned development of ContainerUI. Milestones are ordered by priority and dependency; items within a milestone can be tackled in parallel.

> This roadmap is a living document — priorities may shift as the project grows and community feedback comes in.

---

## Milestone 1 — Foundation `[in progress]`

Core infrastructure and the shell of the application.

- [x] Project setup (SwiftUI, Xcode, dark design language)
- [x] Side panel navigation (Containers, Images, Registries, Documentation, Parameters)
- [x] Loading screen with progress indicator
- [x] Missing-components detection and install prompt
- [ ] Connect to Apple's container system runtime via CLI/XPC
- [ ] Persist app state across launches (last selected section, window size)

---

## Milestone 2 — Containers

Browse and manage running and stopped containers.

- [ ] List all containers with name, image, status, and uptime
- [ ] Start / stop / restart a container
- [ ] Delete a container (with confirmation)
- [ ] View container logs (live-streaming)
- [ ] View container details (ports, mounts, environment variables, resource usage)
- [ ] Execute a command inside a running container (shell access)

---

## Milestone 3 — Images

Browse and manage local images.

- [ ] List all local images with name, tag, size, and creation date
- [ ] Pull an image from a registry
- [ ] Delete an image (with confirmation)
- [ ] Inspect an image (layers, config, history)
- [ ] Build an image from a Dockerfile (path picker + build log)

---

## Milestone 4 — Registries

Connect to public and private container registries.

- [ ] Add / remove a registry (URL, credentials stored in Keychain)
- [ ] Browse a registry's available images and tags
- [ ] Push a local image to a registry
- [ ] Support Docker Hub, GitHub Container Registry, and custom registries

---

## Milestone 5 — Documentation

In-app documentation and onboarding.

- [ ] Embedded quick-start guide for Apple's container system
- [ ] Contextual help panels in each section
- [ ] Link to official Apple documentation and community resources

---

## Milestone 6 — Parameters & Preferences

Settings for the app and the container runtime.

- [ ] Runtime configuration (resource limits, default registry, storage path)
- [ ] Appearance preferences (accent color, font size)
- [ ] Keyboard shortcuts overview
- [ ] Check for app updates

---

## Milestone 7 — Polish & Distribution

Prepare ContainerUI for public release.

- [ ] App icon and branding assets
- [ ] Localisation (English primary, French included)
- [ ] Accessibility audit (VoiceOver, keyboard navigation)
- [ ] Notarisation and Gatekeeper compliance
- [ ] GitHub Releases with pre-built `.dmg`
- [ ] Homebrew cask (`brew install --cask containerui`)

---

## Future Ideas

These are not scheduled but may be picked up based on demand:

- Menu-bar icon with quick container status
- Compose / multi-container stacks support
- System notifications (container crash, image pull complete)
- CLI companion tool (`containerui` command)
- Plugin / extension system
