# CamboStyle

CamboStyle is a production-oriented Flutter application for AI stencil workflows, secure authentication, gallery browsing, and account management. The codebase follows a feature-first clean architecture approach to support long-term maintainability and scale.

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-Framework-02569B?logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-Language-0175C2?logo=dart&logoColor=white">
  <img alt="Architecture" src="https://img.shields.io/badge/Architecture-Clean%20and%20Modular-1E293B">
</p>

## Overview

This project is built for Android, iOS, and Web using Flutter. It combines modular feature development with a shared core infrastructure layer, including networking, dependency injection, secure storage, and reusable UI foundations.

## Core Features

- Authentication flow: sign up, login, email verification, OTP verification, and password reset
- Home flow: gallery, item details, my stencils, pricing, and payment method screens
- Profile flow: profile management, password/security, privacy/legal, and terms/services screens
- Stencil flow: style customization and generated stencil result view
- Shared infrastructure: API client, secure token handling, connectivity checks, and local caching support

## Architecture

The project follows clean architecture and feature-based module separation.

- `lib/core/`: shared foundations (base classes, DI, network, services, theme, utilities)
- `lib/moduls/auth/`: authentication module with `data`, `domain`, and `presentation`
- `lib/moduls/home/`: home module with controllers, data models, and presentation screens
- `lib/moduls/stencil/`: stencil module with controllers, data models, and presentation screens

## Project Structure

```text
lib/
|-- core/
|   |-- base/
|   |-- common/
|   |-- constants/
|   |-- di/
|   |-- extensions/
|   |-- init/
|   |-- navigation/
|   |-- network/
|   |-- services/
|   |-- theme/
|   `-- utils/
|-- moduls/
|   |-- auth/
|   |   |-- data/
|   |   |-- domain/
|   |   `-- presentation/
|   |-- home/
|   |   |-- controllers/
|   |   |-- data/
|   |   |-- models/
|   |   `-- presentation/
|   `-- stencil/
|       |-- controllers/
|       |-- data/
|       |-- models/
|       `-- presentation/
`-- main.dart

assets/
`-- images/
```

## Tech Stack

- State management and navigation: `get`
- Networking: `dio`
- Local storage and caching: `hive`, `hive_flutter`
- Secure storage: `flutter_secure_storage`
- Connectivity: `connectivity_plus`
- UI utilities: `google_fonts`, `flutter_svg`, `cached_network_image`, `pin_code_fields`
- Media and file handling: `image_picker`, `file_picker`, `pdf`, `share_plus`, `open_filex`

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK compatible with `sdk: ^3.11.0`
- Android Studio/Xcode (for mobile builds)

Validate your environment:

```bash
flutter doctor
```

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

### API Base URL Configuration (Optional)

You can override the API base domain using `API_BASE_URL`:

```bash
flutter run --dart-define=API_BASE_URL=https://your-api-domain.com
```

If not provided, defaults are:

- Android emulator: `http://10.0.2.2:5000`
- Web/Desktop/iOS: `http://127.0.0.1:5000`

## Build Commands

```bash
flutter build apk --release
flutter build ios --release
flutter build web --release
```

## Development Notes

- Entry point: `lib/main.dart`
- Application shell: `GetMaterialApp`
- Package name: `cembostyle`
- Current version: `1.0.0+1`

## Copyright

Copyright (c) 2026 CamboStyle. All rights reserved.
