# littlefish_feature_products

Products feature package for the littlefish merchant app.

## Overview

This package contains product-related business logic, UI components, services, and state management for the littlefish merchant application.

## Structure

The package follows a clean architecture pattern with the following folders:

- **state/** - Redux state management (actions, reducers, middleware, selectors)
- **ui/** - Flutter widgets and screens for product features
- **services/** - Business logic and API service implementations
- **models/** - Data models and entities for products

## Dependencies

This package depends on:
- `littlefish_core` - Core utilities and shared functionality
- `redux` / `flutter_redux` - State management
- `redux_thunk` - Async action support

## Usage

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  littlefish_feature_products:
    path: ../features/products/littlefish_feature_products
```

## Getting Started

Import the package in your Dart code:

```dart
import 'package:littlefish_feature_products/littlefish_feature_products.dart';
```
