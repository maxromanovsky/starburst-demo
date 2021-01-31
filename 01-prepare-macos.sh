#!/usr/bin/env bash
set -x
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install prerequisites
brew install bash python3 google-cloud-sdk kubernetes-cli prestosql

# Update google-cloud-sdk
gcloud components update --quiet
