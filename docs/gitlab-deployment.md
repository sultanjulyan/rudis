# GitLab Deployment Guide

This guide explains how to deploy Rudis to GitLab using GitLab CI/CD and GitLab Pages.

## Overview

Rudis includes GitLab CI/CD configuration that provides the same functionality as the GitHub Actions workflows:

| Feature | GitHub Actions | GitLab CI/CD |
|---------|---------------|--------------|
| Markdown Linting | `.github/workflows/lint.yml` | `.gitlab-ci.yml` (markdownlint job) |
| Documentation | `.github/workflows/docs.yml` | `.gitlab-ci.yml` (build-docs, pages jobs) |
| Releases | `.github/workflows/release.yml` | `.gitlab-ci.yml` (release stage jobs) |
| Pages Deployment | GitHub Pages | GitLab Pages |

## Prerequisites

1. A GitLab account and repository
2. GitLab Pages enabled for your project
3. GitLab CI/CD enabled (enabled by default)

## Setup

### 1. Push to GitLab

Push your Rudis repository to GitLab:

```bash
# Add GitLab as a remote
git remote add gitlab https://gitlab.com/your-username/rudis.git

# Push to GitLab
git push gitlab main
```

### 2. Enable GitLab Pages

GitLab Pages is enabled automatically when a `pages` job runs successfully. The documentation will be available at:

```text
https://your-username.gitlab.io/rudis/
```

### 3. CI/CD Pipeline

The pipeline runs automatically on:

- **Push to main branch**: Runs lint, docs build, and release jobs
- **Merge requests**: Runs lint job only
- **Manual trigger**: All jobs can be triggered manually from the GitLab CI/CD interface

## Pipeline Stages

### Lint Stage

- **markdownlint**: Validates all Markdown files for consistent formatting

### Build Stage

- **build-docs**: Builds DocFX documentation
  - Only runs on changes to `docs/**`
  - Outputs to `public/` directory for GitLab Pages

### Deploy Stage

- **pages**: Deploys documentation to GitLab Pages
  - Requires successful `build-docs` job
  - Only runs on main branch

### Release Stage

Multiple jobs work together to create releases:

1. **get-version**: Calculates the next version from git tags
2. **check-release**: Checks if a release already exists
3. **create-packages**: Creates release ZIP packages
4. **generate-release-notes**: Generates changelog from git history
5. **create-release**: Creates the GitLab release with artifacts

## Configuration Files

### Main Configuration

- [.gitlab-ci.yml](../.gitlab-ci.yml) - Main CI/CD configuration

### Scripts

Located in `.gitlab/scripts/`:

- `get-next-version-gitlab.sh` - Version calculation
- `check-release-exists-gitlab.sh` - Release existence check
- `generate-release-notes-gitlab.sh` - Release notes generation
- `create-gitlab-release.sh` - Release creation helper

### Shared Scripts

The release package creation script is shared with GitHub Actions:

- `.github/workflows/scripts/create-release-packages.sh`

## Environment Variables

GitLab CI/CD provides these variables automatically:

| Variable | Description |
|----------|-------------|
| `CI_JOB_TOKEN` | Authentication token for GitLab API |
| `CI_PROJECT_ID` | Numeric project ID |
| `CI_API_V4_URL` | GitLab API endpoint |
| `CI_PROJECT_URL` | Full project URL |
| `CI_PAGES_URL` | GitLab Pages URL |
| `CI_DEFAULT_BRANCH` | Default branch (usually `main`) |

## Customization

### Changing the Documentation Path

If your documentation is in a different directory, update the `build-docs` job:

```yaml
build-docs:
  script:
    - cd your-docs-folder  # Change this
    - docfx docfx.json
```

### Manual Triggers

All jobs support manual triggering via `CI_PIPELINE_SOURCE == "web"`. Go to:

CI/CD → Pipelines → Run pipeline

### Release Frequency

By default, releases are created when changes are made to:

- `memory/**`
- `scripts/**`
- `templates/**`
- `.gitlab-ci.yml`

Modify the `rules:` section in the `.gitlab-ci.yml` to change this behavior.

## Troubleshooting

### Pages Not Deploying

1. Ensure the `pages` job completed successfully
2. Check that artifacts are in the `public/` directory
3. Verify GitLab Pages is enabled in **Settings → Pages**

### Release Artifacts Not Found

1. Ensure `.github/workflows/scripts/create-release-packages.sh` is executable
2. Check that the `create-packages` job completed successfully
3. Verify artifacts are in `.genreleases/` directory

### API Authentication Errors

The `CI_JOB_TOKEN` should work for most operations. If you need additional permissions:

1. Go to **Settings → CI/CD → Variables**
2. Add a `GITLAB_TOKEN` variable with appropriate permissions
3. Update scripts to use `PRIVATE-TOKEN: $GITLAB_TOKEN` header

## Differences from GitHub

| Feature | GitHub | GitLab |
|---------|--------|--------|
| Token variable | `GITHUB_TOKEN` | `CI_JOB_TOKEN` |
| Output variables | `$GITHUB_OUTPUT` | dotenv artifacts |
| Release CLI | `gh release` | `release-cli` |
| Pages directory | Any (via action) | Must be `public/` |
| Environment URL | `steps.deployment.outputs.page_url` | `CI_PAGES_URL` |

## Support

For GitLab-specific issues:

- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [GitLab Pages Documentation](https://docs.gitlab.com/ee/user/project/pages/)
- [GitLab Releases Documentation](https://docs.gitlab.com/ee/user/project/releases/)
