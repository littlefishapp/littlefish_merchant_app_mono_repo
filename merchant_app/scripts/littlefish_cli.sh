#!/bin/bash

# Function to check if running in Azure DevOps pipeline
is_azure_pipeline() {
    [[ ! -z "${BUILD_BUILDID}" ]]
}

# Function to check and use Flutter command (fvm or direct)
use_flutter() {
    local command=$1
    shift # Remove first argument, leaving the rest intact

    if is_azure_pipeline; then
        # In Azure Pipeline, use Flutter directly
        fvm flutter $command "$@"
    elif command -v fvm &>/dev/null; then
        # Locally, use fvm if available
        fvm flutter $command "$@"
        #  flutter $command "$@"
    else
        # Fallback to direct Flutter command if fvm is not installed
        flutter $command "$@"
    fi
}

# Function to display help
print_help() {
    echo "Usage: script.sh <command> [options]"
    echo ""
    echo "Commands:"
    echo "  set [--environment]            Switch to a specific environment configuration"
    echo "                                 Use --environment format (e.g., --app, --staging, --prod)"
    echo "                                 Built-in environments: --app, --mpp, --bpos"
    echo "  set_client <client> <env>      Swaps the assets for a specific client and environment(dev, uat, prod, etc.) . e,g sbsa prod"
    echo "  set save <target>              Save the current configuration as the base for a target"
    echo "  build <platform> <flavor> <env_file> <output_type> [main_target] [release_mode] [output_dir] [output_name]"
    echo "                                  Build the app for Android or iOS"
    echo "                                  platform: 'android' or 'ios'"
    echo "                                  flavor: Build flavor (e.g., lflfcompdev)"
    echo "                                  env_file: Path to Dart define environment file"
    echo "                                  output_type: 'apk' or 'aab' (Android only)"
    echo "                                  main_target: Entry point file (default: lib/main.dart)"
    echo "                                  release_mode: '--release' or '--debug' (default: --release)"
    echo "                                  output_dir: Custom output directory (default: build/outputs)"
    echo "                                  output_name: Custom output file name (default: flavor)"
    echo "  clean                          Clean the Flutter project and iOS pods"
    echo "  install                        Install Flutter and iOS dependencies"
    echo "  install flutter                 Installs flutter in the event it is not present"
    echo "  help                           Display this help message"
    echo ""
    echo "Examples:"
    echo "  ./script.sh set --app          Switch to app configuration"
    echo "  ./script.sh set --staging      Switch to staging configuration"
    echo "  ./script.sh set save staging   Save current config as staging base"
    echo "  ./script.sh build android lflfcompdev env_files/lflfcompdev.json apk"
    echo "  ./script.sh build ios lflfcompdev env_files/lflfcompdev.json"
    echo "  ./script.sh clean"
    echo "  ./script.sh install"
}
# Function to manage client-specific assets
set_client_assets() {
    local client=$1
    local environment=$2
    
    # 1. --- Define Paths ---
    local client_asset_dir="client_assets/$client"
    local common_asset_dir="$client_asset_dir/common"
    local env_asset_dir="$client_asset_dir/$environment"
    local target_asset_dir="assets/client_specific"

    # Define Injector Paths
    local injector_base_path="lib/app/injectors/icon_injector/icon_injector.dart"
    local client_injector_source="${injector_base_path}.for_${client}"
    local default_injector_source="${injector_base_path}.for_littlefish"

    # Define the master list of all possible client-specific subdirectories
    # THIS LIST MUST MATCH WHAT IS IN PUBSPEC.yaml assets paths
    local master_client_paths=(
        "icons"
        "images"
        "logos"
        "pdfs"
    )

    # 2. --- Input Validation ---
    if [ -z "$client" ] || [ -z "$environment" ]; then
        echo "Error: Client and environment must be specified."
        echo "Usage: ./scripts/littlefish_cli.sh set_client <client_name> <environment>"
        exit 1
    fi
    if [ ! -d "$client_asset_dir" ]; then
        echo "Error: Client asset directory not found at '$client_asset_dir'"
        exit 1
    fi

    echo "Setting assets for client: '$client', environment: '$environment'..."
    
    # 3. --- Clean and Recreate Target Directory ---
    echo "Completely clearing '$target_asset_dir'..."
    rm -rf "$target_asset_dir"
    mkdir -p "$target_asset_dir"

    # 4. --- Pre-create all master directories to prevent build errors ---
    echo "Ensuring all standard asset directories exist..."
    for path in "${master_client_paths[@]}"; do
        mkdir -p "$target_asset_dir/$path"
    done
    
    # 5. --- Copy Assets with Override Logic ---
    if [ -d "$common_asset_dir" ]; then
        echo "Copying common assets to '$target_asset_dir'..."
        rsync -a "$common_asset_dir/" "$target_asset_dir/"
    else
        echo "No 'common' assets folder found for '$client'. Skipping."
    fi

    if [ -d "$env_asset_dir" ]; then
        echo "Copying '$environment' assets to '$target_asset_dir'..."
        rsync -a "$env_asset_dir/" "$target_asset_dir/"
    else
        echo "Warning: No specific asset folder found for environment '$environment'."
    fi

    echo "Assets for '$client' ($environment) set successfully in '$target_asset_dir'."

    # 6. --- Handle Icon Injector Swapping ---
    echo "Configuring Icon Injector for '$client'..."

    if [[ -f "$client_injector_source" ]]; then
        cp -f "$client_injector_source" "$injector_base_path"
        echo "Injector switched: $client_injector_source -> $injector_base_path"
    else
        echo "No specific injector found for '$client' ($client_injector_source)."
        
        if [[ -f "$default_injector_source" ]]; then
            echo "Falling back to default: $default_injector_source"
            cp -f "$default_injector_source" "$injector_base_path"
        else
            echo "CRITICAL: Default injector ($default_injector_source) not found! Icon injection may fail."
        fi
    fi
}

# Function to switch configurations
switch_config() {
    local target=$1
    local base_files=(
        "pubspec.yaml"
        "android/app/build.gradle"
        "android/settings.gradle"
        "lib/app/injectors/payment_injector.dart"
        "android/gradle/wrapper/gradle-wrapper.properties"
        "android/app/src/main/AndroidManifest.xml"
        "android/gradle.properties"
    )

    for base_file in "${base_files[@]}"; do
        local target_file="${base_file}.${target}"
        if [[ -f "$target_file" ]]; then
            cp -f "$target_file" "$base_file"
            echo "Switched to $target_file and copied to $base_file"
        else
            if [[ "$base_file" != "android/settings.gradle" ]]; then
                echo "Error: $target_file does not exist."
                exit 1
            else
                echo "No custom $target_file found. Using default $base_file."
            fi
        fi
    done

    use_flutter "pub" get
    echo "Configuration switched successfully for $target."
}

# Function to switch manifest
switch_manifest() {
    local target=$1
    local base_files=(
        "android/app/src/main/AndroidManifest.xml"
    )

    for base_file in "${base_files[@]}"; do
        local target_file="${base_file}.${target}"
        if [[ -f "$target_file" ]]; then
            cp -f "$target_file" "$base_file"
            echo "Switched to $target_file and copied to $base_file"
        else
            echo "No custom $target_file found. Using default $base_file."
        fi
    done

    echo "Manifest files switched successfully for $target."
}

# Function to save current config
save_config() {
    local target=$1
    local base_files=(
        "pubspec.yaml"
        "android/app/build.gradle"
        "android/settings.gradle"
        "lib/app/injectors/payment_injector.dart"
        "android/app/src/main/AndroidManifest.xml"
        "android/gradle.properties"
        "android/build.gradle"
        "android/gradle/wrapper/gradle-wrapper.properties"
        
    )

    for base_file in "${base_files[@]}"; do
        local target_file="${base_file}.${target}"
        cp "$base_file" "$target_file"
        echo "Saved $base_file as $target_file"
    done

    echo "Configuration saved successfully for $target."
}

# Function to build iOS app
build_ios_app() {
    local flavor=$1
    local env_file=$2
    local release_mode=${3:-"--release"}
    local output_dir=${4:-"build/outputs"}
    local output_name=${5:-"$flavor"}

    echo "Setting up iOS build environment..."

    # Install dependencies
    cd ios && pod install && cd ..

    if is_azure_pipeline; then
        # Cloud build setup
        # Ensure required variables are set
        if [ -z "$APPLE_TEAM_ID" ] || [ -z "$PROVISIONING_PROFILE_NAME" ] || [ -z "$BUNDLE_ID" ]; then
            echo "Error: Required environment variables are not set for cloud build."
            echo "Required: APPLE_TEAM_ID, PROVISIONING_PROFILE_NAME, BUNDLE_ID"
            exit 1
        fi

        # Dynamically set the PRODUCT_BUNDLE_IDENTIFIER in the project.pbxproj file
        echo "Setting PRODUCT_BUNDLE_IDENTIFIER to $BUNDLE_ID"
        sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = .*;/PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID;/g" ios/Runner.xcodeproj/project.pbxproj

        # Create export options for App Store
        cat >exportOptions.plist <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>$APPLE_TEAM_ID</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>$BUNDLE_ID</key>
        <string>$PROVISIONING_PROFILE_NAME</string>
    </dict>
</dict>
</plist>
EOL
    else
        # Local build setup - use automatic signing
        cat >exportOptions.plist <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
EOL
    fi

    # Build the app
    echo "Building iOS app for flavor: $flavor"
    use_flutter "build" ios \
        --flavor "$flavor" \
        --dart-define-from-file "$env_file" \
        "$release_mode" \
        --no-codesign

    # Create archive directory
    mkdir -p build/ios/archive

    # Archive the app
    echo "Creating archive..."
    xcodebuild -workspace ios/Runner.xcworkspace \
        -scheme "$flavor" \
        -configuration Release \
        -archivePath build/ios/archive/Runner.xcarchive \
        archive

    # Create output directory
    mkdir -p "$output_dir"

    # Export IPA
    echo "Exporting IPA..."
    xcodebuild -exportArchive \
        -archivePath build/ios/archive/Runner.xcarchive \
        -exportOptionsPlist exportOptions.plist \
        -exportPath "$output_dir"

    # Rename the output file if needed
    if [ -f "$output_dir/Runner.ipa" ]; then
        mv "$output_dir/Runner.ipa" "$output_dir/${output_name}.ipa"
    fi

    # Cleanup
    rm -f exportOptions.plist

    echo "Build completed. IPA location: $output_dir/${output_name}.ipa"
}

# Updated build_app function
build_app() {
    local platform=$1
    local flavor=$2
    local env_file=$3
    local output_type=$4
    local main_target=${5:-"lib/main.dart"}
    local release_mode=${6:-"--release"}
    local output_dir=${7:-"build/outputs"}
    local output_name=${8:-"$flavor"}
    local target_platform=${9:-"android-arm64"}

    # Ensure the output directory exists
    mkdir -p "$output_dir"

    # Check if environment file exists
    if [[ ! -f "$env_file" ]]; then
        echo "Error: Environment file $env_file does not exist."
        exit 1
    fi

    # Build for iOS
    if [[ "$platform" == "ios" ]]; then
        build_ios_app "$flavor" "$env_file" "$release_mode" "$output_dir" "$output_name"

    # Build for Android
    elif [[ "$platform" == "android" ]]; then

        if [[ "$output_type" == "apk" ]]; then
            echo "Building APK for flavor: $flavor"
            use_flutter "build" apk \
                -t "$main_target" \
                --flavor "$flavor" \
                --dart-define-from-file "$env_file" \
                "$release_mode" \
                --target-platform $target_platform \
                --split-per-abi
            mv build/app/outputs/flutter-apk/*.apk "$output_dir/${output_name}.apk"

        elif [[ "$output_type" == "aab" ]]; then
            echo "Building AAB for flavor: $flavor"
            use_flutter "build" appbundle \
                -t "$main_target" \
                --flavor "$flavor" \
                --dart-define-from-file "$env_file" \
                "$release_mode"
            mv build/app/outputs/bundle/$flavor$release_mode/*.aab "$output_dir/${output_name}.aab"

        else
            echo "Error: Invalid output type for Android. Use 'apk' or 'aab'."
            exit 1
        fi
    else
        echo "Error: Invalid platform. Use 'android' or 'ios'."
        exit 1
    fi

    echo "Build completed successfully."
    echo "Output: $output_dir/${output_name}"
}

install_dependencies() {
    echo "Installing dependencies..."
    use_flutter "pub" get
}

install_ios() {
    echo "Installing dependencies..."
    use_flutter "pub" get
    cd ios && pod install && cd ..
    echo "Dependencies installed."
}

clean_project() {
    echo "Cleaning project..."
    use_flutter "clean"
    echo "Removing iOS Pod files..."
    rm -rf ios/Pods ios/Podfile.lock ios/.symlinks ios/Flutter/Flutter.framework ios/Flutter/Flutter.podspec
    echo "Project cleaned."
}

# [Rest of the script remains the same]

# Main command routing
case $1 in
set)
    case $2 in
    --app)
        switch_config "for_app"
        ;;
    --mpp)
        switch_config "for_mpp"
        ;;
    --bpos)
        switch_config "for_bpos"
        ;;
    save)
        save_config "for_${3:-default}"
        ;;
    *)
        if [[ "$2" == "--"* ]]; then
            env_name=${2#--}
            switch_config "for_${env_name}"
        else
            echo "Error: Invalid option for 'set'. Use '--environment_name' format."
            print_help
            exit 1
        fi
        ;;
    esac
    ;;
set_client)
    set_client_assets "$2" "$3"
    ;;

switch_manifest)
    switch_manifest "for_${2}"
    ;;
build)
    build_app "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}"
    ;;
clean)
    clean_project
    ;;
install)
    if [ "$2" = "ios" ]; then
        install_ios
    else
        install_dependencies
    fi
    ;;
help)
    print_help
    ;;
*)
    echo "Error: Invalid command."
    print_help
    exit 1
    ;;
esac
