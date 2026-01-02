# littlefish_feature_payments

Payments feature package for littlefish merchant app. Contains payment types, payment processing, and payment-related business logic.

## Structure

- `lib/state/` - Redux state management (actions, reducers, middleware, selectors)
- `lib/ui/` - Flutter widgets and screens
- `lib/services/` - Business logic and API services
- `lib/models/` - Data models and entities

## Dependencies

This package depends on:
- `littlefish_core` - Core utilities and shared functionality
- `littlefish_core_utils` - Additional utility functions
- `redux` / `flutter_redux` / `redux_thunk` - State management

## Usage

```dart
import 'package:littlefish_feature_payments/littlefish_feature_payments.dart';
```
