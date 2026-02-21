# AGENTS.md

## Purpose
- This repository builds a custom bootc image named `cozzite-nvidia-open`.
- The current base is `ghcr.io/ublue-os/bazzite-gnome-nvidia-open:latest`.
- The image customizations are defined primarily in `build_files/build.sh`.
- Build automation is in `.github/workflows/build.yml` and `.github/workflows/build-disk.yml`.

## Rule File Discovery
- Cursor rules: none found (`.cursorrules` and `.cursor/rules/` do not exist).
- Copilot rules: none found (`.github/copilot-instructions.md` does not exist).
- If these files are added later, treat them as authoritative project-specific guidance.

## Repository Layout
- `Containerfile`: image build entrypoint.
- `build_files/build.sh`: package and service customization script.
- `Justfile`: local build, lint, and VM helper commands.
- `disk_config/disk.toml`: qcow2/raw disk build customization.
- `disk_config/iso.toml`: ISO installer customization and kickstart switch target.
- `.github/workflows/build.yml`: OCI image CI build and push to GHCR.
- `.github/workflows/build-disk.yml`: disk artifact (ISO) workflow.

## Core Build Commands
- Build OCI image locally: `just build`.
- Build OCI image with explicit tag: `just build localhost/cozzite-nvidia-open latest`.
- Build ISO from local image: `just build-iso`.
- Rebuild ISO (force image rebuild first): `just rebuild-iso`.
- Build qcow2 image: `just build-qcow2`.
- Build raw image: `just build-raw`.
- Run ISO in local VM helper: `just run-vm-iso`.

## Lint and Format Commands
- Lint shell scripts: `just lint`.
- Format shell scripts: `just format`.
- Validate Justfile syntax: `just check`.
- Auto-fix Justfile syntax: `just fix`.

## Single-Test / Targeted Verification
- There is no unit-test framework in this repo.
- Use targeted checks as the single-test equivalent:
  - Single shell script lint: `shellcheck build_files/build.sh`.
  - Single Justfile syntax check: `just --unstable --fmt --check -f Justfile`.
  - Single package resolution check in container:
    - `sudo podman run --rm ghcr.io/ublue-os/bazzite-gnome-nvidia-open:latest dnf5 repoquery zed`.
  - Single image smoke build:
    - `podman build --pull=newer --tag localhost/cozzite-nvidia-open:smoke .`.

## CI Behavior
- `build.yml` runs on push, PR, schedule, and manual dispatch.
- `build.yml` publishes `cozzite-nvidia-open` to `ghcr.io/<owner>/cozzite-nvidia-open`.
- `build-disk.yml` currently builds `anaconda-iso` artifacts only.
- S3 upload is optional in `build-disk.yml`; artifact upload is sufficient.

## Coding Conventions

### General
- Prefer minimal, surgical edits.
- Preserve existing file structure and naming patterns.
- Keep changes deterministic and reproducible.
- Do not add new tooling unless required.

### Shell Script Style (`build_files/*.sh`)
- Use `#!/bin/bash` and strict mode: `set -ouex pipefail`.
- Prefer explicit flags (`-y`, `--enablerepo=...`) over implicit defaults.
- Keep commands idempotent where possible.
- Use absolute paths for generated files in system locations.
- Group commands by intent: install, configure, cleanup.
- Avoid unnecessary subshells and command chains that hide failures.

### Imports / External Sources
- For package repos, import signing keys before install when needed.
- Prefer official upstream repositories for third-party tools.
- Pin by channel when exact version pinning is not practical.
- Document non-default repositories in the script section where used.

### Formatting
- Shell: keep one command per line unless line continuation improves readability.
- YAML: two-space indentation, avoid tabs.
- TOML: keep arrays multiline when they are long.
- Markdown: concise sections with actionable command examples.

### Types and Data Handling
- Treat shell variables as strings unless arithmetic is required.
- Quote variable expansions by default (`"${var}"`).
- For lists, prefer newline-delimited blocks in YAML/TOML for readability.

### Naming Conventions
- Image name: `cozzite-nvidia-open`.
- Keep filenames descriptive (`VM-ISO-INSTALL.md`, `disk_config/iso.toml`).
- Use lowercase for new file names unless a project convention differs.

### Error Handling
- Fail fast by default via strict mode.
- Use explicit soft-fail only for non-critical best-effort steps.
- Current acceptable best-effort step: GNOME package removal (`|| true`).
- Always clean temp files in success paths.

### Containerfile Guidance
- Keep customization logic in `build_files/build.sh`, not inline in `Containerfile`.
- Preserve `bootc container lint` as final validation layer.
- Keep cache mounts and tmpfs mounts in place for build performance.

### Workflow Guidance
- Keep `IMAGE_NAME` consistent across workflows and `Justfile`.
- Prefer stable pinned action SHAs for GitHub Actions.
- If adding inputs, ensure non-dispatch triggers still have sane defaults.

## Change Validation Checklist
- Run `just check`.
- Run `just lint`.
- Run `just build`.
- Run `just build-iso`.
- Confirm ISO exists at `output/bootiso/install.iso`.
- Verify expected packages in built image where possible:
  - `cosmic-session`, `cosmic-greeter`, `ghostty`, `code`, `zed`.
- Verify binary existence:
  - `command -v opencode` in the built image/runtime.

## Agent Workflow Tips
- Read `Containerfile`, `build_files/build.sh`, and both workflows before editing.
- Keep image name and registry references synchronized.
- When editing `disk_config/iso.toml`, confirm the `bootc switch` target is correct.
- If a build fails on package resolution, test with a one-off `podman run ... dnf5 ...`.
- Prefer fixing root cause over adding broad `--skip-broken` behavior.

## Expected Package Set
- Desktop/session stack:
  - `cosmic-session`, `cosmic-greeter`, `xdg-desktop-portal-cosmic`.
- Developer apps:
  - `ghostty`, `code`, `zed`, `opencode`.
- Display manager behavior:
  - `display-manager.service` should point to COSMIC greeter.
- GNOME reduction is best-effort:
  - Remove `gdm` and `gnome-shell` when possible, but do not hard fail if dependency constraints change.

## Troubleshooting Patterns
- `dnf5` repo key failures:
  - Ensure key import is present in script before install.
  - Re-run with explicit `--enablerepo=...` for targeted checks.
- COPR package not found:
  - Verify COPR enable succeeded, then run `dnf5 repoquery <pkg>`.
  - Disable COPR after install so it is not left enabled in the image.
- ISO build failures:
  - Confirm `disk_config/iso.toml` exists and is referenced by `Justfile`.
  - Verify local image tag matches the build command parameters.
- VM test failures:
  - Confirm host has `/dev/kvm` and virtualization support enabled.
  - Confirm installer can reach the registry image referenced by kickstart.

## Preferred Validation Order
- Fast checks first: `just check`.
- Then lint: `just lint`.
- Then container build: `just build`.
- Then installer artifact build: `just build-iso`.
- Finally run VM flow: `just run-vm-iso`.

## Non-Goals
- Do not implement host-side `bootc switch` testing in this repo workflow.
- Do not require S3 deployment for ISO validation.
- Do not add unrelated desktop packages without explicit request.
