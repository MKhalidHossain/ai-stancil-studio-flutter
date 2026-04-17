# CamboStyle

A professional Flutter application built with clean architecture principles, designed for secure authentication, home feed experiences, and stencil management workflows.

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.11.0+-02569B?logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.11.0+-0175C2?logo=dart&logoColor=white">
  <img alt="Architecture" src="https://img.shields.io/badge/Architecture-Clean%20Architecture-6A1B9A">
  <img alt="State Management" src="https://img.shields.io/badge/State%20Management-GetX-7B1FA2">
  <img alt="Platforms" src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web-0A0A0A">
</p>

---

## Overview

**CamboStyle** is a Flutter application targeting Android, iOS, and Web. The project is structured around clean architecture and feature-based modules, with clear separation between data, domain, and presentation layers.

The app uses:

- **GetX** for state management, navigation, and dependency injection
- **Dio** for network communication
- **Hive** and **Flutter Secure Storage** for local and secure persistence
- A reusable core layer for shared services, base classes, theme, navigation, and utilities

This repository is intended to serve as a scalable Flutter codebase with reusable patterns for authentication, home feed management, and stencil-related workflows.

---

## Repository

- **GitHub Repository:** `https://github.com/MKhalidHossain/ai-stancil-studio-flutter.git`

### Clone the project

```bash
git clone https://github.com/MKhalidHossain/ai-stancil-studio-flutter.git
cd ai-stancil-studio-flutter
```

---

## Architecture

The project follows a **feature-based clean architecture** approach.

### Core Layer
The `core/` layer contains shared infrastructure and app-wide building blocks:

- Base classes for controllers, repositories, and use cases
- Shared UI components and common widgets
- Constants and app-wide utilities
- Dependency injection setup
- Initialization and bootstrap logic
- Navigation and route management
- Network layer and API configuration
- App services and reusable theme definitions

### Feature Modules
The `moduls/` directory groups business features into isolated modules:

- **Auth** — Login, registration, and OTP workflows
- **Home** — Home feed and dashboard experiences
- **Stencil** — Stencil browsing, viewing, and management

This structure helps keep features modular, testable, and easier to maintain as the codebase grows.

---

## Project Structure

```text
lib/
├── core/
│   ├── base/           # Base classes (controllers, repositories, use cases)
│   ├── common/         # Shared widgets and components
│   ├── constants/      # App-wide constants
│   ├── di/             # Dependency injection bindings
│   ├── extensions/     # Dart extension methods
│   ├── init/           # App initialization logic
│   ├── navigation/     # Route definitions and navigation management
│   ├── network/        # Dio client, interceptors, and API configuration
│   ├── services/       # Platform and background services
│   ├── theme/          # App theme and design tokens
│   └── utils/          # Utility functions and helpers
│
└── moduls/
    ├── auth/           # Authentication flow (login, registration, OTP)
    ├── home/           # Home feed and dashboard
    └── stencil/        # Stencil browsing and management

assets/
└── images/             # Application image assets
```

---

## Tech Stack

### State Management and Navigation
- `get`

### Networking
- `dio`

### Storage and Security
- `hive_flutter`
- `flutter_secure_storage`
- `connectivity_plus`

### Architecture and Utilities
- `dartz`
- `equatable`
- `json_annotation`

### UI and Presentation
- `google_fonts`
- `flutter_svg`
- `cached_network_image`
- `pin_code_fields`

### Device and File Utilities
- `image_picker`
- `file_picker`
- `intl`
- `crypto`

---

## Features

- Secure authentication flow with login, registration, and OTP verification
- Home feed and dashboard foundation
- Stencil browsing and management module
- Feature-first modular architecture
- Reusable core components and infrastructure
- Centralized network layer with Dio
- Local persistence with Hive
- Secure credential storage with platform-secure storage
- GetX-powered navigation and state management
- Scalable project layout for future feature expansion

---

## Prerequisites

Before running the application, make sure the following tools are installed:

| Requirement | Version |
| --- | --- |
| Flutter SDK | `^3.11.0` |
| Dart SDK | `^3.11.0` |
| Android SDK | API 21+ |
| Xcode | 14+ for iOS builds |

You can verify your local Flutter setup with:

```bash
flutter doctor
```

---

## Getting Started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Run the application

```bash
flutter run
```

### 3. Build for release

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web
```

---

## Development Notes

- Entry point: `lib/main.dart`
- The project uses `GetMaterialApp` as the application shell
- Shared assets are configured under `assets/images/`
- Package name in `pubspec.yaml`: `cembostyle`
- Current app version in `pubspec.yaml`: `1.0.0+1`

---

## Dependencies Reference

| Package | Purpose |
| --- | --- |
| `get` | State management and navigation |
| `dio` | HTTP client |
| `hive_flutter` | Local key-value storage |
| `flutter_secure_storage` | Secure credential storage |
| `connectivity_plus` | Network connectivity detection |
| `dartz` | Functional programming utilities |
| `equatable` | Value equality for models |
| `google_fonts` | Custom typography |
| `flutter_svg` | SVG asset rendering |
| `cached_network_image` | Remote image loading |
| `pin_code_fields` | OTP input UI |
| `image_picker` | Camera and gallery access |
| `file_picker` | File selection |
| `intl` | Internationalization and formatting |
| `crypto` | Cryptographic helpers |
| `json_annotation` | JSON serialization annotations |

---

## Flutter Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [GetX Documentation](https://github.com/jonataslaw/getx)

---

## Copyright

© 2026 **CamboStyle**. All rights reserved.

This project, including its source code, assets, documentation, and related materials, is proprietary unless otherwise stated. No part of this repository may be copied, modified, distributed, or reused without prior written permission from the project owner.
