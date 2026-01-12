#!/usr/bin/env bash
set -euo pipefail

# create-github-release.sh
# Create a GitHub release with all template zip files
# Usage: create-github-release.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

# Remove 'v' prefix from version for release title
VERSION_NO_V=${VERSION#v}

gh release create "$VERSION" \
  .genreleases/rudis-template-copilot-sh-"$VERSION".zip \
  .genreleases/rudis-template-copilot-ps-"$VERSION".zip \
  .genreleases/rudis-template-claude-sh-"$VERSION".zip \
  .genreleases/rudis-template-claude-ps-"$VERSION".zip \
  .genreleases/rudis-template-gemini-sh-"$VERSION".zip \
  .genreleases/rudis-template-gemini-ps-"$VERSION".zip \
  .genreleases/rudis-template-cursor-agent-sh-"$VERSION".zip \
  .genreleases/rudis-template-cursor-agent-ps-"$VERSION".zip \
  .genreleases/rudis-template-opencode-sh-"$VERSION".zip \
  .genreleases/rudis-template-opencode-ps-"$VERSION".zip \
  .genreleases/rudis-template-qwen-sh-"$VERSION".zip \
  .genreleases/rudis-template-qwen-ps-"$VERSION".zip \
  .genreleases/rudis-template-windsurf-sh-"$VERSION".zip \
  .genreleases/rudis-template-windsurf-ps-"$VERSION".zip \
  .genreleases/rudis-template-codex-sh-"$VERSION".zip \
  .genreleases/rudis-template-codex-ps-"$VERSION".zip \
  .genreleases/rudis-template-kilocode-sh-"$VERSION".zip \
  .genreleases/rudis-template-kilocode-ps-"$VERSION".zip \
  .genreleases/rudis-template-auggie-sh-"$VERSION".zip \
  .genreleases/rudis-template-auggie-ps-"$VERSION".zip \
  .genreleases/rudis-template-roo-sh-"$VERSION".zip \
  .genreleases/rudis-template-roo-ps-"$VERSION".zip \
  .genreleases/rudis-template-codebuddy-sh-"$VERSION".zip \
  .genreleases/rudis-template-codebuddy-ps-"$VERSION".zip \
  .genreleases/rudis-template-qoder-sh-"$VERSION".zip \
  .genreleases/rudis-template-qoder-ps-"$VERSION".zip \
  .genreleases/rudis-template-amp-sh-"$VERSION".zip \
  .genreleases/rudis-template-amp-ps-"$VERSION".zip \
  .genreleases/rudis-template-shai-sh-"$VERSION".zip \
  .genreleases/rudis-template-shai-ps-"$VERSION".zip \
  .genreleases/rudis-template-q-sh-"$VERSION".zip \
  .genreleases/rudis-template-q-ps-"$VERSION".zip \
  .genreleases/rudis-template-bob-sh-"$VERSION".zip \
  .genreleases/rudis-template-bob-ps-"$VERSION".zip \
  --title "Rudis Templates - $VERSION_NO_V" \
  --notes-file release_notes.md
