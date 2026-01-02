# Littlefish Merchant App Mono Repo

This repository contains the Littlefish Merchant Application and its feature packages, organized as a Flutter/Dart mono repo managed with Melos. The merchant app is a comprehensive point-of-sale (POS) and business management platform designed for retail merchants.

## Repository Overview

The monorepo follows a domain-driven structure with the main `merchant_app` as the primary application and self-contained feature packages under the `features/` directory. Each feature package contains business logic, UI components, services, and state management for a specific domain.

### Architecture Pattern

The repository implements a feature-based architecture where each business domain is encapsulated in its own package. Feature packages are self-contained and implement Redux for state management, making them reusable and testable. All feature packages depend on `littlefish_core` and `littlefish_core_utils` for shared functionality.

## Feature Packages

The following feature packages are available:

| Package | Description | Domain |
|---------|-------------|--------|
| `littlefish_feature_products` | Product catalog management, categories, modifiers, combos | Products |
| `littlefish_feature_security` | Authentication, permissions, user management | Security |
| `littlefish_feature_checkout` | Sales processing, payments, receipts, refunds | Checkout |
| `littlefish_feature_widgets` | Reusable UI components, form fields, common widgets | Widgets |
| `littlefish_feature_business` | Business profile, employees, settings, linked accounts | Business |
| `littlefish_feature_customers` | Customer management, store credit | Customers |
| `littlefish_feature_inventory` | Stock management, stock runs, GRVs | Inventory |
| `littlefish_feature_sales` | Transaction history, tickets | Sales |
| `littlefish_feature_promotions` | Promotions, discounts, marketing | Promotions |
| `littlefish_feature_suppliers` | Supplier management, invoices | Suppliers |
| `littlefish_feature_payments` | Payment types, payment processing | Payments |
| `littlefish_feature_finance` | Expenses, billing, financial management | Finance |
| `littlefish_feature_reports` | Reporting, analytics, data visualization | Reports |
| `littlefish_feature_devices` | Device management, hardware integration | Devices |

### Feature Package Structure

Each feature package follows a consistent structure:

```
littlefish_feature_<domain>/
├── lib/
│   ├── littlefish_feature_<domain>.dart  # Main library file with exports
│   ├── state/                             # Redux state management
│   │   ├── state.dart                     # Barrel file
│   │   ├── <domain>_state.dart           # State class
│   │   ├── <domain>_actions.dart         # Redux actions
│   │   ├── <domain>_reducer.dart         # Redux reducer
│   │   └── <domain>_selectors.dart       # State selectors
│   ├── ui/                                # Flutter widgets and screens
│   │   └── ui.dart                        # Barrel file
│   ├── services/                          # Business logic and API services
│   │   └── services.dart                  # Barrel file
│   └── models/                            # Data models and entities
│       └── models.dart                    # Barrel file
├── pubspec.yaml
└── README.md
```

## Using Melos

This monorepo uses [Melos](https://melos.invertase.dev/) to manage multiple packages.

### Prerequisites

Before setting up the project, ensure you have the following installed:

- **Flutter SDK**: Version 3.35.0 or later
- **Dart SDK**: Version 3.8.0 or later (included with Flutter)

### Local Setup

**1. Clone the repository:**

```bash
git clone https://github.com/littlefishapp/littlefish_merchant_app_mono_repo.git
cd littlefish_merchant_app_mono_repo
```

**2. Install Melos globally:**

```bash
dart pub global activate melos
```

Make sure the Dart pub cache bin directory is in your PATH. You can add it by adding this line to your shell profile (`.bashrc`, `.zshrc`, etc.):

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

**3. Bootstrap the workspace:**

```bash
melos bootstrap
```

This command:
- Resolves and downloads all dependencies for every package
- Links local packages together so they can reference each other
- Sets up the workspace for development

**4. Verify the setup:**

```bash
melos list --long
```

This should display all packages in the workspace with their versions and paths.

### Getting Started

Once the local setup is complete, you can start developing:

**Run analysis to check for issues:**

```bash
melos run analyze
```

**Format your code:**

```bash
melos run format
```

**Run tests:**

```bash
melos run test
```

If you encounter any issues during setup, try running `melos clean` followed by `melos bootstrap` to reset the workspace.

### Available Commands

Melos provides several scripts for common development tasks. Run them from the repository root:

**Analyze all packages:**
```bash
melos run analyze
```

**Format all Dart files:**
```bash
melos run format
```

**Check formatting without making changes:**
```bash
melos run format:check
```

**Run tests in all packages:**
```bash
melos run test
```

**Generate code (build_runner):**
```bash
melos run generate
```

**Clean all packages:**
```bash
melos run clean:all
```

**Get dependencies for all packages:**
```bash
melos run get
```

**Upgrade dependencies:**
```bash
melos run upgrade
```

**List outdated dependencies:**
```bash
melos run outdated
```

**Dry run publish to check for issues:**
```bash
melos run publish:check
```

**Version packages based on conventional commits:**
```bash
melos run version
```

### Listing Packages

To see all packages in the workspace:

```bash
melos list
```

For detailed information including paths and versions:

```bash
melos list --long
```

## Adding a New Feature Package

You can add a new feature package using the provided script or manually.

### Using the Script

Run the following command from the repository root:

```bash
./scripts/create_feature_package.sh <domain_name> "<description>"
```

Example:
```bash
./scripts/create_feature_package.sh loyalty "Loyalty program feature package for customer rewards and points management."
```

### Manual Steps

1. Create the package directory structure:
   ```bash
   mkdir -p features/<domain>/littlefish_feature_<domain>/lib/{state,ui,services,models}
   ```

2. Create the `pubspec.yaml` with the following template:
   ```yaml
   name: littlefish_feature_<domain>
   description: <Description of the feature package>
   version: 1.0.0
   publish_to: none

   environment:
     sdk: ">=3.8.0"
   resolution: workspace

   dependencies:
     flutter:
       sdk: flutter
     redux: 5.0.0
     redux_thunk: 0.4.0
     flutter_redux: 0.10.0
     littlefish_core: ^4.2.0
     littlefish_core_utils:
       path: ../../../littlefish_core_mono_repo/packages/utils/littlefish_core_utils

   dev_dependencies:
     flutter_test:
       sdk: flutter
     flutter_lints: ^6.0.0
     mocktail: ^1.0.4

   flutter:
     uses-material-design: true
   ```

3. Create the main library file (`lib/littlefish_feature_<domain>.dart`):
   ```dart
   library littlefish_feature_<domain>;

   export 'state/state.dart';
   export 'ui/ui.dart';
   export 'services/services.dart';
   export 'models/models.dart';
   ```

4. Create barrel files for each subdirectory (`state.dart`, `ui.dart`, `services.dart`, `models.dart`)

5. Add the package to the root `pubspec.yaml` workspace list:
   ```yaml
   workspace:
     - features/<domain>/littlefish_feature_<domain>
   ```

6. Run `melos bootstrap` to link the new package

## Directory Structure

```
littlefish_merchant_app_mono_repo/
├── merchant_app/                          # Main merchant application
│   ├── lib/
│   │   ├── common/                        # Shared UI components
│   │   ├── features/                      # App-specific features
│   │   ├── models/                        # Data models
│   │   ├── redux/                         # Redux state management
│   │   ├── services/                      # API services
│   │   └── ui/                            # UI pages and widgets
│   ├── android/                           # Android configuration
│   └── pubspec.yaml
│
├── features/                              # Feature packages
│   ├── products/littlefish_feature_products/
│   ├── security/littlefish_feature_security/
│   ├── checkout/littlefish_feature_checkout/
│   ├── widgets/littlefish_feature_widgets/
│   ├── business/littlefish_feature_business/
│   ├── customers/littlefish_feature_customers/
│   ├── inventory/littlefish_feature_inventory/
│   ├── sales/littlefish_feature_sales/
│   ├── promotions/littlefish_feature_promotions/
│   ├── suppliers/littlefish_feature_suppliers/
│   ├── payments/littlefish_feature_payments/
│   ├── finance/littlefish_feature_finance/
│   ├── reports/littlefish_feature_reports/
│   └── devices/littlefish_feature_devices/
│
├── scripts/                               # Utility scripts
│   └── create_feature_package.sh          # Script to create new feature packages
│
├── pubspec.yaml                           # Root workspace configuration
└── README.md
```

## Using Feature Packages

To use a feature package in the merchant app or another package, add it as a dependency:

```yaml
dependencies:
  littlefish_feature_products:
    path: ../features/products/littlefish_feature_products
```

Then import and use:

```dart
import 'package:littlefish_feature_products/littlefish_feature_products.dart';
```

## Technology Stack

- **Framework**: Flutter (Dart)
- **State Management**: Redux (5.0.0) with redux_thunk (0.4.0) and flutter_redux (0.10.0)
- **Workspace Management**: Melos
- **Core Dependencies**: littlefish_core (^4.2.0), littlefish_core_utils

## License

LITTLEFISH LICENSE
