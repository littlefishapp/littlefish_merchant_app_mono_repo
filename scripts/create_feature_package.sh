#!/bin/bash

# Script to create a new feature package for the Littlefish Merchant App Mono Repo
# Usage: ./scripts/create_feature_package.sh <domain_name> "<description>"
# Example: ./scripts/create_feature_package.sh loyalty "Loyalty program feature package for customer rewards and points management."

set -e

# Check arguments
if [ -z "$1" ]; then
    echo "Error: Domain name is required"
    echo "Usage: ./scripts/create_feature_package.sh <domain_name> \"<description>\""
    exit 1
fi

DOMAIN_NAME="$1"
DESCRIPTION="${2:-${DOMAIN_NAME^} feature package for littlefish merchant app}"
PACKAGE_NAME="littlefish_feature_${DOMAIN_NAME}"
PACKAGE_DIR="features/${DOMAIN_NAME}/${PACKAGE_NAME}"

# Check if package already exists
if [ -d "$PACKAGE_DIR" ]; then
    echo "Error: Package directory already exists: $PACKAGE_DIR"
    exit 1
fi

echo "Creating feature package: $PACKAGE_NAME"
echo "Directory: $PACKAGE_DIR"
echo "Description: $DESCRIPTION"
echo ""

# Create directory structure
mkdir -p "$PACKAGE_DIR/lib/state"
mkdir -p "$PACKAGE_DIR/lib/ui"
mkdir -p "$PACKAGE_DIR/lib/services"
mkdir -p "$PACKAGE_DIR/lib/models"

# Create pubspec.yaml
cat > "$PACKAGE_DIR/pubspec.yaml" << PUBSPEC
name: $PACKAGE_NAME
description: $DESCRIPTION
version: 1.0.0
publish_to: none

environment:
  sdk: ">=3.8.0"
resolution: workspace

dependencies:
  flutter:
    sdk: flutter

  # Redux state management
  redux: 5.0.0
  redux_thunk: 0.4.0
  flutter_redux: 0.10.0

  # Littlefish core dependencies
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
PUBSPEC

# Create main library file
cat > "$PACKAGE_DIR/lib/${PACKAGE_NAME}.dart" << LIBRARY
/// ${DOMAIN_NAME^} feature package for littlefish merchant app.
///
/// This package contains ${DOMAIN_NAME}-related business logic, UI components,
/// services, and state management.
library $PACKAGE_NAME;

// State management exports
export 'state/state.dart';

// UI component exports
export 'ui/ui.dart';

// Service exports
export 'services/services.dart';

// Model exports
export 'models/models.dart';
LIBRARY

# Create barrel files
cat > "$PACKAGE_DIR/lib/state/state.dart" << STATE
/// State management exports for the ${DOMAIN_NAME} feature package.
///
/// This file exports all Redux state management components including:
/// - State classes
/// - Actions
/// - Reducers
/// - Selectors
/// - Middleware
library;

// TODO: Add state exports here
// export '<domain>_state.dart';
// export '<domain>_actions.dart';
// export '<domain>_reducer.dart';
// export '<domain>_selectors.dart';
STATE

cat > "$PACKAGE_DIR/lib/ui/ui.dart" << UI
/// UI component exports for the ${DOMAIN_NAME} feature package.
///
/// This file exports all Flutter widgets and screens related to ${DOMAIN_NAME}.
library;

// TODO: Add UI exports here
// export 'pages/<domain>_page.dart';
// export 'widgets/<domain>_widget.dart';
UI

cat > "$PACKAGE_DIR/lib/services/services.dart" << SERVICES
/// Service exports for the ${DOMAIN_NAME} feature package.
///
/// This file exports all business logic and API services related to ${DOMAIN_NAME}.
library;

// TODO: Add service exports here
// export '<domain>_service.dart';
SERVICES

cat > "$PACKAGE_DIR/lib/models/models.dart" << MODELS
/// Model exports for the ${DOMAIN_NAME} feature package.
///
/// This file exports all data models and entities related to ${DOMAIN_NAME}.
library;

// TODO: Add model exports here
// export '<domain>_model.dart';
MODELS

# Create README.md
cat > "$PACKAGE_DIR/README.md" << README
# $PACKAGE_NAME

$DESCRIPTION

## Overview

This package is part of the Littlefish Merchant App mono repo and contains all ${DOMAIN_NAME}-related functionality.

## Structure

- \`lib/state/\` - Redux state management (actions, reducers, middleware, selectors)
- \`lib/ui/\` - Flutter widgets and screens
- \`lib/services/\` - Business logic and API services
- \`lib/models/\` - Data models and entities

## Dependencies

- \`littlefish_core\` - Core Littlefish functionality
- \`littlefish_core_utils\` - Utility functions and helpers
- \`redux\` / \`flutter_redux\` / \`redux_thunk\` - State management

## Usage

Add this package as a dependency in your \`pubspec.yaml\`:

\`\`\`yaml
dependencies:
  $PACKAGE_NAME:
    path: ../features/${DOMAIN_NAME}/${PACKAGE_NAME}
\`\`\`

Then import and use:

\`\`\`dart
import 'package:${PACKAGE_NAME}/${PACKAGE_NAME}.dart';
\`\`\`
README

echo ""
echo "Feature package created successfully!"
echo ""
echo "Next steps:"
echo "1. Add the package to the root pubspec.yaml workspace list:"
echo "   - features/${DOMAIN_NAME}/${PACKAGE_NAME}"
echo ""
echo "2. Run 'melos bootstrap' to link the new package"
echo ""
echo "3. Start adding your state, UI, services, and models to the package"
