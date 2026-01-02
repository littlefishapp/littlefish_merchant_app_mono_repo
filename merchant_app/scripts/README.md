# littlefish CLI Setup and Usage Guide

## Overview

The littlefish CLI (littlefish) is a custom command-line tool for managing Flutter projects. It simplifies tasks such as switching environments, building apps, installing dependencies, and cleaning the project. The script ensures seamless operation both locally and in Azure DevOps pipelines.

## Why Use littlefish CLI?

### Key Benefits
	1.	Simplified Workflow:
	•	Handle multiple environments (e.g., app, mpp, bpos) effortlessly.
	•	Unified commands for Android and iOS builds.
	2.	Consistency Across Teams:
	•	Guarantees uniform build processes and configurations.
	•	Easy for new team members to onboard.
	3.	CI/CD Ready:
	•	Integrated for Azure DevOps pipelines with no manual setup.
	4.	Global Availability:
	•	Once installed, the CLI is globally accessible via the littlefish command.

## One-Time Setup (Automated)

### Step 1: Install Globally From Local Folder

Run the following commadn to setup the script globally on your machine: 

``` bash
chmod +x ./scripts/littlefish_cli.sh && sudo ln -sf "$(pwd)/scripts/littlefish_cli.sh" /usr/local/bin/littlefish

```

#### Optional: Install Globally From GitHub

Run the following command to set up the script globally on your machine:

``` bash

git clone https://github.com/littlefishapp/littlefish-flutter-cli.git && \
sudo mv littlefish-flutter-cli/littlefish_cli.sh /usr/local/bin/littlefish && \
sudo chmod +x /usr/local/bin/littlefish && \
rm -rf littlefish-flutter-cli

```

##### What This Does
	1.	Clones the repository from littlefish-flutter-cli.
	2.	Moves the littlefish_cli.sh script to /usr/local/bin for global access.
	3.	Renames the script to littlefish for easy usage.
	4.	Makes the script executable.
	5.	Removes the cloned repository to clean up.


### Step 2: Verify Installation

After running the setup command, verify that the CLI is accessible by typing:

``` bash
littlefish help
```

You should see a list of available commands and their usage.

## Usage

Commands

### Switch Configurations
Switch to a specific environment or local configuration:

littlefish set --app       # Switch to app environment
littlefish set --mpp       # Switch to mpp environment
littlefish set --bpos      # Switch to bpos environment


### Save the current configuration:

littlefish set save app

### Build Apps

#### Android:

``` bash
littlefish build android <flavor> <env_file> <output_type> [main_target] [release_mode] [output_dir] [output_name]
```

##### Example:

``` bash
littlefish build android lflfcompdev env_files/lflfcompdev.json apk
```

#### iOS:

``` bash
littlefish build ios <flavor> <env_file> [main_target] [release_mode] [output_dir] [output_name]
```

##### Example:

``` bash

littlefish build ios lflfcompdev env_files/lflfcompdev.json

```


### Clean the Project

``` bash
littlefish clean
```

### Install Dependencies

``` bash
littlefish install
```

### Help

``` bash
littlefish help
```

# Azure DevOps Setup

The littlefish CLI is designed for seamless integration into Azure DevOps pipelines.

Example Pipeline Configuration

Below is a sample Azure DevOps pipeline leveraging the littlefish CLI.

trigger:
- main  # Adjust branch as needed

pool:
  vmImage: 'ubuntu-latest'

## Sample Steps:

These are samples, please ensure you are able to complete the same output locally and understand the littlefish-cli correctly.

### Step 1: Clone and Install the Script
```bash
- script: |
    git clone https://github.com/littlefishapp/littlefish-flutter-cli.git && \
    sudo mv littlefish-flutter-cli/littlefish_cli.sh /usr/local/bin/littlefish && \
    sudo chmod +x /usr/local/bin/littlefish && \
    rm -rf littlefish-flutter-cli
  displayName: "Install littlefish CLI"
```

### Step 2: Install Dependencies
``` bash
- script: littlefish install
  displayName: "Install Dependencies"
```

### Step 3: Switch to App Configuration
``` bash
- script: littlefish set --app
  displayName: "Switch to App Environment"
```

### Step 4: Build Android APK
``` bash
- script: littlefish build android lflfcompdev env_files/lflfcompdev.json apk
  displayName: "Build Android APK"
```

### Step 5: Build iOS IPA
``` bash
- script: littlefish build ios lflfcompdev env_files/lflfcompdev.json
  displayName: "Build iOS IPA"
```

### Step 6: Clean the Project (Optional)
``` bash
- script: littlefish clean
  displayName: "Clean Project"
```

# Why This Script is a Must-Use

## Key Advantages
	1.	Centralized Control:
	•	Ensures all team members and CI/CD pipelines use consistent configurations.
	2.	Saves Time:
	•	Eliminates repetitive tasks like manual environment switching and dependency installation.
	3.	Global Accessibility:
	•	Once installed, the littlefish command works in any terminal or pipeline.
	4.	Scalability:
	•	Add new environments or build configurations without modifying local setups.
	5.	Ease of Use:
	•	Minimal learning curve for new team members.
	•	Comprehensive commands and help messages.

## Troubleshooting

### Common Issues
	1.	Command Not Found:
	•	Ensure the setup command was run correctly.
	•	Verify the script is in /usr/local/bin:

ls /usr/local/bin/littlefish


	2.	Permission Denied:
	•	Ensure you have the necessary permissions:

sudo chmod +x /usr/local/bin/littlefish


	3.	Missing Dependencies:
	•	Ensure Flutter, fvm, and CocoaPods are installed and configured.

## Support

For further assistance, contact your DevOps team or refer to this guide.