#!/usr/bin/env bash
set -euo pipefail

# check-release-exists-gitlab.sh
# Check if a GitLab release already exists for the given version
# Usage: check-release-exists-gitlab.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

# Use GitLab API to check if release exists
# CI_API_V4_URL is automatically provided by GitLab CI
# CI_PROJECT_ID is automatically provided by GitLab CI
# CI_JOB_TOKEN is automatically provided for API access

RESPONSE=$(curl -s -w "\n%{http_code}" \
  --header "JOB-TOKEN: $CI_JOB_TOKEN" \
  "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/releases/${VERSION}" 2>/dev/null || echo "error")

HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_CODE" = "200" ]; then
  echo "RELEASE_EXISTS=true" > release_check.env
  echo "Release $VERSION already exists, skipping..."
else
  echo "RELEASE_EXISTS=false" > release_check.env
  echo "Release $VERSION does not exist, proceeding..."
fi
