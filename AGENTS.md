# AGENTS.md

## Project concept

Cozzite is a minimal COSMIC overlay for Bazzite GNOME-family images.

Mainline Cozzite variants only do four things:

1. install `cosmic-desktop` and `cosmic-desktop-apps`
2. ensure Noto Sans/mono/emoji fonts are installed
3. remove `gdm` and `gnome-shell` (best-effort)
4. enable `cosmic-greeter.service`

Do not add personal/workstation apps to base variants in `main`.

## Variant map

- `cozzite` <- `ghcr.io/ublue-os/bazzite-gnome:latest`
- `cozzite-nvidia` <- `ghcr.io/ublue-os/bazzite-gnome-nvidia-open:latest`
- `cozzite-dx` <- `ghcr.io/ublue-os/bazzite-dx-gnome:latest`
- `cozzite-dx-nvidia` <- `ghcr.io/ublue-os/bazzite-dx-gnome-nvidia:latest`

`cozzite-personal` is a separate branch/image and not part of mainline base behavior.

## Files that matter most

- `Containerfile`: base image selection and build entrypoint
- `build_files/build.sh`: all OS customization logic
- `.github/workflows/build.yml`: matrix build + publish to GHCR
- `README.md`: user-facing variant and rebase documentation

## Build workflow rules

- Keep the variant matrix in `.github/workflows/build.yml` aligned with README.
- Use `BASE_IMAGE` build arg per matrix entry.
- Keep tags centered on `latest` + dated tags.
- Keep nightly schedule enabled so upstream base updates are picked up.

## Shell script conventions

- Use `#!/bin/bash` and `set -ouex pipefail`.
- Keep commands explicit and deterministic (`dnf5 -y ...`).
- Group logic in order: install, configure, cleanup.
- Use `|| true` only for intentional best-effort behavior.

## Quick checks

- `just check`
- `just lint`
- `just build`

## Notes for coding agents

- There are no Cursor/Copilot rule files in this repo right now.
- Prefer small, surgical edits over broad refactors.
- Keep changes consistent across `README.md`, `build.sh`, and workflow matrix.
