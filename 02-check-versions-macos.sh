#!/usr/bin/env bash
echo "macOS: `sw_vers -productVersion`"
echo "bash: `bash --version | head -n1`"
echo "python: `python3 --version`"
echo "kubectl `kubectl version --client --short`"
echo ""
echo "gcloud:"
gcloud --version
