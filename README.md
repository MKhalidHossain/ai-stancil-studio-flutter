# CamboStyle

A professional Flutter mobile application built with clean architecture principles, featuring secure authentication, home feed, and stencil management modules.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Dependencies](#dependencies)
- [Features](#features)

---

## Overview

CamboStyle is a Flutter application targeting Android, iOS, and Web platforms. It is built following clean architecture patterns with clear separation of concerns across data, domain, and presentation layers. State management is handled via [GetX](https://pub.dev/packages/get), and network communication is performed through [Dio](https://pub.dev/packages/dio).

---

## Architecture

The project follows a **feature-based clean architecture** structure:

- **Core** — Shared infrastructure: networking, services, navigation, DI, theme, utilities, and base classes.
- **Modules** — Self-contained feature modules (auth, home, stencil), each containing its own data, domain, and presentation layers.

---

## Project Structure

```
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
```

---

## Prerequisites

| Requirement | Version |
|-------------|---------|
| Flutter SDK | `^3.11.0` |
| Dart SDK    | `^3.11.0` |
| Android SDK | API 21+ |
| Xcode       | 14+ (for iOS builds) |

---

## Getting Started

**1. Clone the repository**

```bash
git clone <repository-url>
cd cambostyle
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Run the application**

```bash
flutter run
```

**4. Build for release**

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## Dependencies

### Core

| Package | Purpose |
|---------|---------|
| `get` | State management and navigation |
| `dio` | HTTP client |
| `hive` / `hive_flutter` | Local key-value storage |
| `flutter_secure_storage` | Secure credential storage |
| `connectivity_plus` | Network connectivity detection |
| `dartz` | Functional programming utilities (Either, Option) |
| `equatable` | Value equality for domain models |

### UI

| Package | Purpose |
|---------|---------|
| `google_fonts` | Custom typography |
| `flutter_svg` | SVG asset rendering |
| `cached_network_image` | Efficient remote image loading |
| `pin_code_fields` | OTP input component |

### Utilities

| Package | Purpose |
|---------|---------|
| `image_picker` | Camera and gallery access |
| `file_picker` | File system access |
| `intl` | Internationalization and date formatting |
| `crypto` | Cryptographic hashing |
| `json_annotation` | JSON serialization code generation |

---

## Features

- **Authentication** — Secure login, registration, and OTP verification flows
- **Home Feed** — Dynamic content display with API integration
- **Stencil Management** — Browse, view, and manage stencil assets
- **Offline Support** — Local data persistence via Hive
- **Secure Storage** — Sensitive data protected with platform-level encryption
- **Responsive Navigation** — Route management via GetX with named routes
- **Network Layer** — Centralized Dio client with interceptors and error handling

---

## Flutter Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [GetX Documentation](https://github.com/jonataslaw/getx)
