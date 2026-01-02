#!/bin/bash

# LittleFish Development Environment Setup Script
# This script creates the folder structure and checks out repositories


##RUN THESE COMMANDS FROM THE BASE FOLDER OF YOUR PROJECT IN THE TERMINAL
##COMMAND 1:  cd ./scripts 
##COMMAND 2: chmod +x setup-littlefish-env.sh

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions with color
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Validation checks
print_section "Performing System Checks"

# Check if git is installed
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
fi

# Check if tree is installed (optional but useful)
if ! command -v tree &> /dev/null; then
    print_warning "Tree command is not installed. Directory structure display will be limited."
fi

# Repository path variables
BASE="$HOME/source/littlefish"
MOBILE_PACKAGES="$BASE/mobile"
WEB_PACKAGES="$BASE/web"

# Create main directory structure
print_section "Creating Directory Structure"
print_status "Creating directories at $BASE"
mkdir -p "$MOBILE_PACKAGES" "$WEB_PACKAGES"

# Change to base directory
cd "$BASE" || {
    print_error "Failed to change to base directory"
    exit 1
}

# Repository cloning function
clone_repo() {
    local repo_url=$1
    local target_dir=$2
    
    if [ -d "$target_dir" ]; then
        print_warning "Directory $target_dir already exists. Skipping..."
        return
    fi
    
    print_status "Cloning repository into $target_dir..."
    if git clone "$repo_url" "$target_dir"; then
        print_status "Successfully cloned repository into $target_dir"
    else
        print_error "Failed to clone repository into $target_dir"
    fi
}

# Main Applications Setup
print_section "Setting up Main Applications"
print_status "Cloning main application repositories..."

clone_repo "https://github.com/littlefishapp/littlefish_merchant_app.git" "$BASE/littlefish_merchant_app"
clone_repo "https://github.com/littlefishapp/littlefish_pay_app.git" "$BASE/littlefish_pay_app"
clone_repo "https://github.com/littlefishapp/littlefish-web-portal.git" "$BASE/littlefish-web-portal"
clone_repo "https://github.com/littlefishapp/littlefish-ecommerce-web.git" "$BASE/littlefish-ecommerce-web"
clone_repo "https://github.com/littlefishapp/littlefish-merchant.git" "$BASE/littlefish-merchant"

# Mobile Packages Setup
print_section "Setting up Mobile Packages"
print_status "Cloning core packages..."

# Core Packages
clone_repo "https://github.com/littlefishapp/littlefish_core.git" "$MOBILE_PACKAGES/littlefish_core"
clone_repo "https://github.com/littlefishapp/littlefish_interfaces.git" "$MOBILE_PACKAGES/littlefish_interfaces"
clone_repo "https://github.com/littlefishapp/littlefish_core_intent.git" "$MOBILE_PACKAGES/littlefish_core_intent"

print_status "Cloning payment-related packages..."
# Payment Packages
clone_repo "https://github.com/littlefishapp/littlefish_payments_qr.git" "$MOBILE_PACKAGES/littlefish_payments_qr"
clone_repo "https://github.com/littlefishapp/littlefish_payments_pos_bpos.git" "$MOBILE_PACKAGES/littlefish_payments_pos_bpos"
clone_repo "https://github.com/littlefishapp/littlefish_payments_pos_ar.git" "$MOBILE_PACKAGES/littlefish_payments_pos_ar"
clone_repo "https://github.com/littlefishapp/littlefish_payments_cash.git" "$MOBILE_PACKAGES/littlefish_payments_cash"
clone_repo "https://github.com/littlefishapp/littlefish_pay_pos_sdk.git" "$MOBILE_PACKAGES/littlefish_pay_pos_sdk"

print_status "Cloning monitoring and analytics packages..."
# Monitoring & Analytics Packages
clone_repo "https://github.com/littlefishapp/littlefish_reports.git" "$MOBILE_PACKAGES/littlefish_reports"
clone_repo "https://github.com/littlefishapp/littlefish_monitoring_firebase.git" "$MOBILE_PACKAGES/littlefish_monitoring_firebase"
clone_repo "https://github.com/littlefishapp/littlefish_analytics_firebase.git" "$MOBILE_PACKAGES/littlefish_analytics_firebase"
clone_repo "https://github.com/littlefishapp/littlefish_auth_firebase.git" "$MOBILE_PACKAGES/littlefish_auth_firebase"
clone_repo "https://github.com/littlefishapp/littlefish_observability_firebase.git" "$MOBILE_PACKAGES/littlefish_observability_firebase"

print_status "Cloning auxiliary packages..."
# Auxiliary Packages
clone_repo "https://github.com/littlefishapp/feature-flag-configurations.git" "$MOBILE_PACKAGES/feature-flag-configurations"
clone_repo "https://github.com/littlefishapp/littlefish_config_launchdarkly.git" "$MOBILE_PACKAGES/littlefish_config_launchdarkly"
clone_repo "https://github.com/littlefishapp/littlefish_auditing.git" "$MOBILE_PACKAGES/littlefish_auditing"
clone_repo "https://github.com/littlefishapp/littlefish_notifications_signalr.git" "$MOBILE_PACKAGES/littlefish_notifications_signalr"
clone_repo "https://github.com/littlefishapp/littlefish_data_hive.git" "$MOBILE_PACKAGES/littlefish_data_hive"

# Final Verification
print_section "Verifying Setup"
if command -v tree &> /dev/null; then
    print_status "Directory structure:"
    tree "$BASE" -L 2
else
    print_status "Directory structure (limited view):"
    ls -R "$BASE"
fi

print_section "Setup Complete"
print_status "Development environment is ready at: $BASE"
print_status "Total repositories cloned: $(find "$BASE" -name ".git" | wc -l)"