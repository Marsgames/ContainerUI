# ContainerUI

> A macOS desktop application for Apple's native container system — built with SwiftUI.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-6-orange.svg)](https://swift.org)

---

## What is ContainerUI?

ContainerUI is an open-source macOS desktop application that provides a graphical interface for managing containers using **Apple's native container system** (introduced in macOS 26 Tahoe). Think of it as a Podman Desktop or Docker Desktop — but built natively for macOS with SwiftUI, respecting Apple's design language while adding its own visual identity.

The app gives you a clear, dark-themed interface to manage containers, images, and registries without ever touching the command line.

## Features (current)

- Dark, minimal UI with a consistent design language
- Side panel navigation: Containers, Images, Registries, Documentation, Parameters
- Loading screen with initialization progress
- Prompt to install missing required components

## Screenshots

> _Screenshots will be added as the UI matures._

## Requirements

- macOS 26 Tahoe or later
- Apple Silicon Mac (the native container system requires it)
- Xcode 26+

## Getting Started

```bash
git clone https://github.com/your-org/ContainerUI.git
cd ContainerUI
open ContainerUI.xcodeproj
```

Build and run the `ContainerUI` scheme in Xcode.

## Project Structure

```
ContainerUI/
├── ContainerUI/          # Main app target
│   ├── ContainerUIApp.swift
│   ├── ContentView.swift
│   ├── SidePanelView.swift
│   ├── HomeView.swift
│   ├── SideButtonWidget.swift
│   └── Extensions/
│       └── Color+Extension.swift
├── Wireframes/           # Design references
└── ContainerUI.xcodeproj/
```

## Design Philosophy

ContainerUI uses a **dark-first** design: deep charcoal backgrounds (`#1D1D1D`), green accents for progress and active states, and orange accents for counts and highlights. The goal is a focused, distraction-free experience that feels at home on macOS without mimicking the standard light-mode system style.

## Roadmap

See [ROADMAP.md](ROADMAP.md) for the planned feature set and milestones.

## Contributing

Contributions are welcome! Please open an issue to discuss your idea before submitting a pull request. There are no formal contribution guidelines yet — they will be added as the project grows.

## License

MIT — see [LICENSE](LICENSE) for details.
