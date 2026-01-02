# Littlefish Feature Models

Shared domain models package for the littlefish merchant app. This package contains all common data models organized by domain, providing a single source of truth for model definitions across all feature packages.

## Purpose

This package centralizes all domain models that are shared across multiple feature packages. Instead of duplicating models in each feature package, all packages reference this shared models package.

## Structure

```
lib/
├── littlefish_feature_models.dart    # Main library file
└── models/
    ├── shared/                       # Shared utilities and base models
    │   ├── enums.dart
    │   ├── country.dart
    │   ├── form_field.dart
    │   └── ...
    ├── stock/                        # Stock/inventory models
    ├── customers/                    # Customer models
    ├── suppliers/                    # Supplier models
    ├── staff/                        # Employee models
    ├── store/                        # Business profile models
    ├── settings/                     # Settings and configuration models
    ├── tax/                          # Tax models
    ├── billing/                      # Billing models
    ├── expenses/                     # Expense models
    ├── finance/                      # Finance models
    ├── products/                     # Product models
    ├── promotions/                   # Promotion models
    ├── sales/                        # Sales models
    ├── reports/                      # Report models
    ├── analysis/                     # Analysis models
    ├── device/                       # Device models
    ├── security/                     # Security models
    ├── permissions/                  # Permission models
    ├── online/                       # Online store models
    ├── workspaces/                   # Workspace models
    ├── activation/                   # Activation models
    ├── assets/                       # Asset models
    └── cache/                        # Cache models
```

## Usage

Add this package as a dependency in your feature package's `pubspec.yaml`:

```yaml
dependencies:
  littlefish_feature_models:
    path: ../../models/littlefish_feature_models
```

Then import the models you need:

```dart
import 'package:littlefish_feature_models/littlefish_feature_models.dart';

// Or import specific domains
import 'package:littlefish_feature_models/models/customers/customers.dart';
import 'package:littlefish_feature_models/models/stock/stock.dart';
```

## Dependencies

- `littlefish_core: ^4.2.0`
- `littlefish_core_utils`
- `json_annotation: ^4.9.0`

## Development

To generate JSON serialization code:

```bash
dart run build_runner build --delete-conflicting-outputs
```
