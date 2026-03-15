#!/bin/bash

# Exit immediately if any command fails.
# This prevents the script from continuing in a broken state.
#set -e


# ------------------------------------------------------------
# Dependency Check
# ------------------------------------------------------------
# Verify that required system commands exist before running the script.
# If any command is missing, the script stops with an error.
for cmd in apt dpkg tee; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: required command '$cmd' is not installed or not in PATH."
        exit 1
    fi
done


# ------------------------------------------------------------
# Path and Environment Variables
# ------------------------------------------------------------
# Determine important paths relative to the script location.

# Absolute path to the folder containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Repository root directory (one level above install/)
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Package list file used for tool installation
PACKAGE_FILE="$REPO_ROOT/packages/packages.txt"

# Workspace directory where runtime data will be stored
WORKSPACE_DIR="/home/${SUDO_USER:-$USER}/toolbox"

# Directory where setup logs will be written
LOG_DIR="$REPO_ROOT/logs"

# Timestamp used for log file naming
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"

# Full log file path
LOG_FILE="$LOG_DIR/setup-$TIMESTAMP.log"


# ------------------------------------------------------------
# Logging Setup
# ------------------------------------------------------------
# Ensure the logs directory exists
mkdir -p "$LOG_DIR"

# Redirect all output (stdout and stderr) to both:
# 1. the terminal
# 2. the log file
exec > >(tee -a "$LOG_FILE") 2>&1


# ------------------------------------------------------------
# Package File Validation
# ------------------------------------------------------------
# Confirm that the package list exists before proceeding.
if [[ ! -f "$PACKAGE_FILE" ]]; then
    echo "Error: package file not found at $PACKAGE_FILE"
    exit 1
fi


# ------------------------------------------------------------
# Script Start Information
# ------------------------------------------------------------
# Print key information useful for troubleshooting.
echo "Starting toolbox setup..."
echo "Repository root: $REPO_ROOT"
echo "Package file: $PACKAGE_FILE"
echo "Log file: $LOG_FILE"


# ------------------------------------------------------------
# System Update
# ------------------------------------------------------------
# Update repository indexes and upgrade installed packages.
echo "Updating package lists..."
sudo apt update

echo "Upgrading installed packages..."
sudo apt upgrade -y


# ------------------------------------------------------------
# Package Installation
# ------------------------------------------------------------
# Read package names from packages.txt and install them.
echo "Installing packages from packages.txt..."

# Counters for install summary
installed_count=0
skipped_count=0
missing_count=0

while IFS= read -r package; do

    # Skip blank lines and comments in the package list
    if [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]]; then
        continue
    fi

        # Check if package exists in repository
    if ! apt-cache policy "$package" | grep -q Candidate; then
        echo "WARNING: Package not found in repositories: $package"
        ((missing_count++))
        continue
    fi

    # Check if the package is already installed
    if dpkg -s "$package" >/dev/null 2>&1; then
        echo "Already installed: $package"
        ((skipped_count++))
    else
        echo "Installing: $package"
        sudo apt install -y "$package"
        ((installed_count++))
    fi

done < "$PACKAGE_FILE"


# ------------------------------------------------------------
# Workspace Creation
# ------------------------------------------------------------
# Create directories used during red team operations.
echo "Creating workspace folders..."

mkdir -p "$WORKSPACE_DIR/recon"
mkdir -p "$WORKSPACE_DIR/scans"
mkdir -p "$WORKSPACE_DIR/exploits"
mkdir -p "$WORKSPACE_DIR/loot"
mkdir -p "$WORKSPACE_DIR/notes"


# ------------------------------------------------------------
# Installation Summary
# ------------------------------------------------------------
# Display statistics about the installation process.
echo ""
echo "----------------------------------------"
echo "Installation Summary"
echo "----------------------------------------"
echo "Installed packages : $installed_count"
echo "Skipped packages   : $skipped_count"
echo "Missing packages   : $missing_count"
echo "----------------------------------------"
echo ""


# ------------------------------------------------------------
# Script Completion
# ------------------------------------------------------------
echo "Setup complete."