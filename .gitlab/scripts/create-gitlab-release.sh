#!/usr/bin/env bash
set -euo pipefail

# create-gitlab-release.sh
# Create a GitLab release with all template zip files
# Note: The actual release is created via the GitLab CI release: keyword
# This script is used for any additional release setup
# Usage: create-gitlab-release.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

# Remove 'v' prefix from version for display
VERSION_NO_V=${VERSION#v}

echo "Preparing GitLab release for version $VERSION_NO_V"
echo "Release artifacts are in .genreleases/"

# List the artifacts that will be attached to the release
echo ""
echo "Release artifacts:"
ls -la .genreleases/*.zip 2>/dev/null || echo "No artifacts found"

# The actual release creation is handled by GitLab CI's release: keyword
# This script is mainly for logging and any pre-release setup
echo ""
echo "Release will be created by GitLab CI release mechanism"
