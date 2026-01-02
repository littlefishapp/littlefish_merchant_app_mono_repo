# Littlefish Merchant

Transforming SME operations

## Getting Started 🚀

This project uses the **littlefish CLI** to simplify development and CI/CD workflows. The CLI ensures consistency across flavors and reduces the complexity of commands.

For detailed build process documentation, see [BUILD_PROCESS.md](docs/BUILD_PROCESS.md).

### Why Use the littlefish CLI?

- **Simplifies Workflow**: Handles configurations, dependencies, and builds for all flavors
- **Consistent Environment**: Enforces uniform processes for local and CI/CD setups
- **Time-Saving**: Eliminates repetitive setup tasks
- **Enhanced Build Process**: Improved iOS/Android build configurations and error handling

### Setting Up the littlefish CLI

#### Prerequisites
- MacOS operating system
- Terminal access
- Project repository cloned locally
- Flutter 3.19.2
- Java 17

#### Flutter & Java Setup

1. Install Flutter 3.19.2:
   ```bash
   # Download Flutter SDK from official source
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.19.2-stable.zip
   
   # Extract and add to PATH
   unzip flutter_macos_3.19.2-stable.zip
   export PATH="$PATH:`pwd`/flutter/bin"
   
   # Verify installation
   flutter --version   # Should show 3.19.2
   ```

2. Install Java 17:
   ```bash
   # Using Homebrew (recommended)
   brew tap homebrew/cask-versions
   brew install --cask temurin17
   
   # Verify installation
   java -version   # Should show version 17
   ```

3. Configure environment:
   ```bash
   flutter doctor    # Check for any missing dependencies
   flutter pub get   # Install Flutter dependencies
   ```

#### One-Time Setup

1. Navigate to your project root directory:
```bash
cd path/to/your/project
```

2. Make the CLI script executable and create a global symlink:
```bash
chmod +x ./scripts/littlefish_cli.sh && sudo ln -sf "$(pwd)/scripts/littlefish_cli.sh" /usr/local/bin/littlefish
```

3. Verify the installation:
```bash
littlefish help
```
You should see the list of available commands.

> To uninstall the CLI: `sudo rm /usr/local/bin/littlefish`

### Using the littlefish CLI

The CLI supports various environments through the `set` command:

```bash
littlefish set --app    # Switch to app configuration
littlefish set --mpp    # Switch to MPP configuration
littlefish set --bpos   # Switch to BPOS configuration
```

#### Quick Start Examples

Build an Android APK for different environments:

```bash
# Development Build
littlefish set --app
littlefish build android lflfposdev env_files/lflfposdev.json apk

# Production Build
littlefish set --app
littlefish build android lflfposprod env_files/lflfposprod.json apk
```

#### Common Commands

```bash
# Install project dependencies
littlefish install

# Clean the project
littlefish clean

# Save current configuration
littlefish set save my_config

# Build iOS app
littlefish build ios myFlavor env_files/myenv.json
```

### Available Commands

- `set [--environment]`: Switch configuration environment
- `set save <target>`: Save current configuration
- `build`: Build the app for Android/iOS
- `clean`: Clean project and pods
- `install`: Install dependencies
- `help`: Display help information

For detailed command usage:
```bash
littlefish help
```

## Development Workflow

After setting up the CLI, your typical development workflow might look like this:

1. Switch to desired environment:
   ```bash
   littlefish set --app
   ```

2. Install dependencies:
   ```bash
   littlefish install
   ```

3. Build your app:
   ```bash
   littlefish build android myFlavor env_files/myenv.json apk
   ```

## Additional Tools

For other development tasks:

```bash
# Generate code with build runner
dart pub run build_runner build --delete-conflicting-outputs

# Create launcher icons
dart pub run flutter_launcher_icons
```

## Reports Engine

The application includes a flexible reporting engine that supports multiple layout versions and configurations for both POS and mobile app environments.

### Layout Versions

The reporting engine supports three distinct layout versions:

1. **Default Layout** (`/lib/features/reports/layouts/default/`)
   - Simple list-based interface
   - Shows reports based on user permissions
   - Basic navigation to individual report pages

2. **V1 Layout** (`/lib/features/reports/layouts/v1/mobile/`)
   - Uses ReportCenterWidget for dynamic report loading
   - Integrates with the reporting service backend
   - Supports real-time report generation and viewing

3. **V2 Layout** (`/lib/features/reports/layouts/v2/`)
   - Enhanced UI with section headers
   - Integrated app download QR code widget
   - Improved navigation and organization

### Configuration System

The reporting engine uses a configuration system to determine which layout to display:

```dart
// Layout selection based on device type
if (isPOS) {
  layout = configService.getStringValue(
    key: 'config_pos_report_center_layout',
    defaultValue: 'default',
  );
} else {
  layout = configService.getStringValue(
    key: 'config_app_report_center_layout',
    defaultValue: 'default',
  );
}
```

All layouts share common business logic through the ReportCenterVM, which handles:
- Business ID management
- Endpoint configuration
- Report version control
- Layout selection based on device type

### Implementation Details

The reporting engine:
1. Uses Redux for state management (`reportVersion` in AppSettingsState)
2. Supports different configurations for POS and mobile app environments
3. Maintains consistent report logic across all layout versions
4. Integrates with the backend reporting service for data retrieval

#### Template System

The reporting engine uses a template-based system where:
- Each report is defined by a template in the backend service
- Templates specify the report structure, data sources, and visualization
- All layout versions use the same templates, ensuring consistent data presentation
- The ReportSettings class configures how templates are processed:
  ```dart
  ReportSettings(
    endpoint: vm.endPoint,      // API endpoint for report service
    configuration: {},          // Template-specific configuration
  )
  ```

#### Data Flow

Reports are generated using:
1. **Business Context**: Uses `businessId` from the store to scope data
2. **Service Integration**: 
   - Connects to reporting service via configured `endPoint`
   - Supports both Metabase and BigQuery (BQ) data sources
   - Handles real-time data fetching and caching

#### Layout Versioning

The three layout versions (default, v1, v2) differ only in their UI presentation:
- All versions use identical data fetching and processing logic
- Templates and data models remain consistent across versions
- Only the visual organization and navigation patterns change
- New layouts can be added without modifying the underlying report generation

This architecture ensures that regardless of the selected layout, reports maintain consistent functionality and accuracy while allowing UI flexibility for different use cases.

### LaunchDarkly Configuration

The reporting engine and app download features are controlled by LaunchDarkly feature flags:

#### Report Layout Flags

1. **config_pos_report_center_layout**
   - Controls the layout version for POS devices
   - Values: `"default"`, `"v1"`, `"v2"`
   - Default: `"default"`
   - Example:
     ```dart
     layout = configService.getStringValue(
       key: 'config_pos_report_center_layout',
       defaultValue: 'default',
     );
     ```

2. **config_app_report_center_layout**
   - Controls the layout version for mobile app
   - Values: `"default"`, `"v1"`, `"v2"`
   - Default: `"default"`
   - Example:
     ```dart
     layout = configService.getStringValue(
       key: 'config_app_report_center_layout',
       defaultValue: 'default',
     );
     ```

#### App Download Feature Flag

3. **config_app_download_url**
   - Configures the URL for mobile app downloads
   - Used by the GetApp QR code widget
   - Default: `"https://littlefishapp.com/"`
   - Example:
     ```dart
     appUrl = configService.getStringValue(
       key: 'config_app_download_url',
       defaultValue: 'https://littlefishapp.com/',
     );
     ```

These flags can be configured in LaunchDarkly to:
- A/B test different report layouts
- Roll out new versions gradually
- Configure app download URLs per environment
- Enable/disable features for specific user segments

### GetApp Feature

The GetApp feature allows users to easily download the mobile app by scanning a QR code from POS devices. This feature is integrated into the v2 report layout and can be configured through LaunchDarkly.

#### Implementation

The GetApp widget is implemented using:
1. **QR Code Generation**:
   ```dart
   QrImageView(
     data: widget.url,    // URL from LaunchDarkly config
     version: QrVersions.auto,
     size: 320,
   )
   ```

2. **Redux Integration**:
   - Uses StoreViewModel for state management
   - Connects to the Redux store via StoreConnector
   - Updates URL dynamically based on configuration changes

3. **Configuration**:
   - URL controlled by `config_app_download_url` flag
   - Default URL: `"https://littlefishapp.com/"`
   - Can be customized per environment or user segment

#### Usage

To enable the GetApp feature:
1. Configure the `config_app_download_url` flag in LaunchDarkly
2. Set the report center layout to v2 using appropriate layout flag
3. The QR code will automatically appear in the report center

The feature is designed to be:
- Non-intrusive: Appears as a banner in the report center
- Configurable: URL can be changed without app updates
- Responsive: Works across different screen sizes
- Maintainable: Uses separate layout files for easy updates

## Need Help?

If you encounter any issues with the CLI:

1. Ensure you're in the project root directory
2. Check file permissions
3. Verify the symbolic link is correct
4. Run `littlefish help` for command usage

For more information about specific commands and options, use the help command:
```bash
littlefish help
```

# Verify apk siganture

apksigner verify --verbose --print-certs app-armeabi-v7a-absazapaxprod-release.apk  