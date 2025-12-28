#!/bin/bash
# Bash script to update all submodules
# This script initializes and updates all Git submodules in the repository

set -e  # Exit on any error

echo "Initializing and updating all submodules..."

# Initialize submodules if not already initialized
if git submodule init; then
    echo "Submodules initialized."
else
    echo "Error: Failed to initialize submodules." >&2
    exit 1
fi

# Update all submodules to their latest commits
if git submodule update --remote --merge; then
    echo "All submodules have been updated successfully!"
else
    echo "Error: Failed to update submodules." >&2
    exit 1
fi
