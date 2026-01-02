# littlefish_feature_customers

Customers feature package for littlefish merchant app. Contains customer management, store credit, and customer-related business logic.

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
import 'package:littlefish_feature_customers/littlefish_feature_customers.dart';
```
