# Build Process Documentation

## Overview
This document outlines the build process for the Littlefish Merchant app, including recent improvements to the build system and configuration management.

## Build Configuration Management

### Environment Configurations
The app supports multiple environment configurations:
- App (`--app`)
- MPP (`--mpp`)
- BPOS (`--bpos`)

Switch between configurations using:
```bash
littlefish set --app    # Switch to app configuration
littlefish set --mpp    # Switch to MPP configuration
littlefish set --bpos   # Switch to BPOS configuration
```

### Version Management
Version numbers follow the format: `{major}.{minor}.{patch}+{build}-{flavor}`
Current version: 1.17.1+54

## Build Process

### Prerequisites
- MacOS for iOS builds
- Android Studio for Android builds
- Flutter SDK
- littlefish CLI tool installed

### Installing the CLI Tool
```bash
chmod +x ./scripts/littlefish_cli.sh
sudo ln -s "$(pwd)/scripts/littlefish_cli.sh" /usr/local/bin/littlefish
```

### Common Build Commands

#### Installing Dependencies
```bash
littlefish install              # Install project dependencies
littlefish install flutter     # Install Flutter if not present
```

#### Building for Android
```bash
# Development APK
littlefish build android {flavor} env_files/{env}.json apk

# Production AAB
littlefish build android {flavor} env_files/{env}.json aab
```

#### Building for iOS
```bash
littlefish build ios {flavor} env_files/{env}.json
```

### Build Outputs
- Android APK/AAB: `build/outputs/{filename}`
- iOS IPA: `build/outputs/{filename}.ipa`

## Signing Configuration

### Android
The project uses the following signing configurations:
- LF configuration for production builds
- Development signing handled automatically

### iOS
Two signing configurations are supported:
1. Development (Local builds):
   - Automatic signing
   - Development provisioning profiles
2. App Store (CI/CD):
   - Manual signing
   - Required environment variables:
     - APPLE_TEAM_ID
     - PROVISIONING_PROFILE_NAME
     - BUNDLE_ID

## Troubleshooting

### Common Issues
1. Missing environment file
   - Ensure the specified environment file exists
   - Check file path is correct

2. Signing Issues
   - For iOS: Verify team ID and provisioning profile
   - For Android: Ensure keystore properties are correctly set

### Debug Information
The build process now includes verbose logging:
- Flavor value logging
- Use case value logging
- Build parameter validation

## Recent Changes

### Build Script Improvements
1. Enhanced iOS build process
   - Better error handling
   - Automatic development/production configuration
   - Improved archive and export process

2. Android Build Updates
   - Gradle caching enabled
   - Simplified signing configuration
   - Support for custom output names and directories

3. CLI Enhancements
   - Added Flutter installation command
   - Improved error messages
   - Better parameter validation

### Configuration Management
- Streamlined environment switching
- Automated dependency installation
- Enhanced version control across configurations
