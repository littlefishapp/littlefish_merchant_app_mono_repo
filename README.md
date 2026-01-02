# Littlefish Payments Mono Repo

This repository contains the payment processing libraries, POS integrations, and SoftPOS implementations for the Littlefish platform, organized as a Flutter/Dart mono repo managed with Melos. It provides the payment infrastructure that Littlefish mobile applications depend on for processing transactions across multiple payment providers and terminal types.

## Repository Overview

The monorepo follows a domain-driven structure with `littlefish_payments` as the foundational dependency for all other packages. Each domain area contains provider-specific implementations that integrate with the core payment abstractions, enabling flexibility to add new payment providers without changing application code.

### Architecture Pattern

The repository implements a gateway/adapter pattern where abstract payment interfaces are defined in the core `littlefish_payments` package and concrete implementations exist in provider-specific packages. This allows applications to depend on abstractions rather than concrete implementations, making it easy to add new payment providers (e.g., adding a new POS terminal integration or SoftPOS provider).

## Using Melos

This monorepo uses [Melos](https://melos.invertase.dev/) to manage multiple packages. Melos simplifies dependency management, running scripts across packages, and versioning.

### Prerequisites

Before setting up the project, ensure you have the following installed:

- **Flutter SDK**: Version 3.35.0 or later
- **Dart SDK**: Version 3.8.0 or later (included with Flutter)

You can verify your installation by running:

```bash
flutter --version
dart --version
```

### Local Setup

Follow these steps to set up the repository for local development:

**1. Clone the repository:**

```bash
git clone https://github.com/littlefishapp/littlefish_payments_mono_repo.git
cd littlefish_payments_mono_repo
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

### Package Categories

Packages are organized into categories for filtering:

- **core**: littlefish_payments (core payment abstractions)
- **pos**: POS terminal integration packages
- **softpos**: SoftPOS provider packages
- **sdks**: Native SDK wrapper packages

You can filter commands by category using the `--scope` flag:

```bash
melos run analyze --scope="*pos*"
```

### Adding a New Package

When adding a new package to the monorepo:

1. Create the package directory under the appropriate domain folder in `packages/`
2. Add `resolution: workspace` to the package's `pubspec.yaml` after the environment section
3. Add the package path to the root `pubspec.yaml` workspace list
4. Run `melos bootstrap` to link the new package

## Domain to Package Mapping

The packages are organized by domain under the `packages/` directory. Each domain contains one or more packages that implement functionality for that area.

### Core Payment Library (`littlefish_payments/`)

| Package | Description | Key Dependencies |
|---------|-------------|------------------|
| `littlefish_payments` | Core payment abstractions, gateway interfaces, transaction models, and payment processing logic | `littlefish_core`, `littlefish_notifications_signalr`, `nfc_manager` |

### POS Integrations (`packages/pos/`)

| Package | Description | Key Dependencies |
|---------|-------------|------------------|
| `littlefish_payments_pos_ar` | African Resonance POS integration | `littlefish_payments`, `littlefish_core_intent` |
| `littlefish_payments_pos_bpos` | Broad POS payments integration | `littlefish_payments`, `pos_sdk` |
| `littlefish_payments_pos_fnb` | FNB POS integration and gateway implementation | `littlefish_payments`, `littlefish_hardware_manager` |
| `littlefish_payments_pos_tps` | TPS plugin for payment terminal integration | `littlefish_payments`, `littlefish_pay_tps_sdk`, `geolocator` |
| `littlefish_payments_pos_verifone` | Verifone Nexo intent integration layer | `littlefish_payments`, `littlefish_core_intent`, `xml` |
| `littlefish_payments_payshap` | PayShap instant payment integration | `littlefish_payments`, `qr_flutter`, `flutter_bloc` |

### SoftPOS Integrations (`packages/softpos/`)

| Package | Description | Key Dependencies |
|---------|-------------|------------------|
| `littlefish_payments_softpos_wizzit` | Wizzit SoftPOS SDK integration | `littlefish_payments`, `littlefish_pay_wizzit_sdk` |
| `littlefish_payments_softpos_halo_dot` | HaloDot payment gateway integration | `littlefish_payments`, `halo_sdk_flutter_plugin` |

### Native SDKs (`packages/sdks/`)

| Package | Description | Key Dependencies |
|---------|-------------|------------------|
| `pos_sdk` | Native POS SDK wrapper for v1.1.14 poslink reservation | `plugin_platform_interface`, `dartz` |

## Using Packages in Applications

To use packages from this monorepo in a Littlefish application, add them as dependencies in your application's `pubspec.yaml`:

```yaml
dependencies:
  littlefish_payments:
    git:
      url: https://github.com/littlefishapp/littlefish_payments_mono_repo.git
      path: littlefish_payments
  littlefish_payments_pos_verifone:
    git:
      url: https://github.com/littlefishapp/littlefish_payments_mono_repo.git
      path: packages/pos/littlefish_payments_pos_verifone
  littlefish_payments_softpos_wizzit:
    git:
      url: https://github.com/littlefishapp/littlefish_payments_mono_repo.git
      path: packages/softpos/littlefish_payments_softpos_wizzit
```

## Core Services

The `littlefish_payments` package provides foundational payment services and abstractions:

### Payment Gateways

The core package defines abstract gateway interfaces for different payment types:

- **POS Payment Gateway**: Interface for traditional POS terminal integrations
- **SoftPOS Payment Gateway**: Interface for software-based POS solutions
- **QR Payment Gateway**: Interface for QR code-based payments
- **Cash Payment Gateway**: Interface for cash transaction handling
- **Mobile Money Payment Gateway**: Interface for mobile money integrations

### Payment Services

```dart
import 'package:littlefish_payments/littlefish_payments.dart';

// Access payment services through dependency injection
final posPaymentService = LittleFishCore.instance.get<IPosPaymentService>();
```

Key services include:
- **IPosPaymentService**: Abstract interface for POS payment operations
- **PosPaymentManagerService**: Manages POS payment workflows and terminal communication

### Transaction Models

The package provides comprehensive models for:
- Transaction processing and status tracking
- Receipt generation and formatting
- Terminal configuration and registration
- Customer and order management
- Account and theme settings

## Directory Structure

```
littlefish_payments_mono_repo/
├── littlefish_payments/              # Core payment library (foundation)
│   ├── lib/
│   │   ├── gateways/                 # Payment gateway abstractions
│   │   ├── managers/                 # Payment flow managers
│   │   ├── models/                   # Transaction, receipt, terminal models
│   │   ├── services/                 # Payment service interfaces
│   │   └── utils/                    # Payment utilities
│   └── pubspec.yaml
│
├── packages/
│   ├── pos/                          # POS terminal integrations
│   │   ├── littlefish_payments_pos_ar/
│   │   ├── littlefish_payments_pos_bpos/
│   │   ├── littlefish_payments_pos_fnb/
│   │   ├── littlefish_payments_pos_tps/
│   │   ├── littlefish_payments_pos_verifone/
│   │   └── littlefish_payments_payshap/
│   │
│   ├── softpos/                      # SoftPOS provider integrations
│   │   ├── littlefish_payments_softpos_wizzit/
│   │   └── littlefish_payments_softpos_halo_dot/
│   │
│   └── sdks/                         # Native SDK wrappers
│       └── littlefish_pay_bpos_sdk/
│
├── apps/                             # Example/test applications
│   └── littlefish_pay_app/
│
├── pubspec.yaml                      # Root workspace configuration
└── README.md
```

## License

LITTLEFISH LICENSE
