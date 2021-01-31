#!/usr/bin/env bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install prerequisites
brew install bash python3 google-cloud-sdk kubernetes-cli

# Update google-cloud-sdk
gcloud components update --quiet
