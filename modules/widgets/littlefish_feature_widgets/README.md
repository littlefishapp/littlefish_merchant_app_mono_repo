# littlefish_feature_widgets

Widgets feature package for the littlefish merchant app.

## Overview

This package contains reusable widget components, UI elements, services, and state management for the littlefish merchant application.

## Structure

The package follows a clean architecture pattern with the following folders:

- **state/** - Redux state management (actions, reducers, middleware, selectors)
- **ui/** - Reusable Flutter widgets and UI components
- **services/** - Business logic and service implementations
- **models/** - Data models and entities for widgets

## Dependencies

This package depends on:
- `littlefish_core` - Core utilities and shared functionality
- `redux` / `flutter_redux` - State management
- `redux_thunk` - Async action support

## Usage

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  littlefish_feature_widgets:
    path: ../features/widgets/littlefish_feature_widgets
```

## Getting Started

Import the package in your Dart code:

```dart
import 'package:littlefish_feature_widgets/littlefish_feature_widgets.dart';
```
