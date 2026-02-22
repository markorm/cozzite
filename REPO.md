# REPO.md

This file is for repository maintainers/contributors.

## Project scope

Mainline Cozzite variants are minimal COSMIC overlays on Bazzite GNOME-family images.

Base variants should only:

1. install `cosmic-desktop` and `cosmic-desktop-apps`
2. ensure Noto Sans/mono/emoji fonts are installed
3. remove `gdm` and `gnome-shell` (best-effort)
4. enable `cosmic-greeter.service`

Do not add personal/workstation apps to base variants in `main`.

## Variant and branch map

| Image | Base image | Branch |
| --- | --- | --- |
| `cozzite` | `ghcr.io/ublue-os/bazzite-gnome:latest` | `main` |
| `cozzite-nvidia` | `ghcr.io/ublue-os/bazzite-gnome-nvidia-open:latest` | `cozzite-nvidia` |
| `cozzite-dx` | `ghcr.io/ublue-os/bazzite-dx-gnome:latest` | `cozzite-dx` |
| `cozzite-dx-nvidia` | `ghcr.io/ublue-os/bazzite-dx-nvidia-gnome:latest` | `cozzite-dx-nvidia` |
| `cozzite-personal` | `ghcr.io/markorm/cozzite-dx-nvidia:latest` | `cozzite-personal` |

`cozzite-personal` should include personal packages (`micro`, `ghostty`, `btop`) and does not belong in `main`.

## Key files

- `Containerfile`: build entrypoint, `BASE_IMAGE` selection via build arg
- `build_files/build.sh`: all system customization logic
- `.github/workflows/build.yml`: matrix container build + push + sign
- `.github/workflows/build-disk.yml`: manual disk/ISO workflow
- `README.md`: end-user rebase documentation
- `AGENTS.md`: coding-agent guidance

## CI policy

- `build.yml` builds the variant matrix and publishes to GHCR.
- Triggers: push/PR on `main`, `workflow_dispatch`, and nightly schedule.
- Nightly build remains enabled to pick up upstream `latest` changes.
- Keep workflow matrix aligned with `README.md` and `AGENTS.md`.

## Local maintainer commands

- `just check`
- `just lint`
- `just build`

Optional disk/ISO commands:

- `just build-iso`
- `just build-qcow2`

## Editing guardrails

- Keep changes small and surgical.
- Keep shell scripts deterministic (`#!/bin/bash`, `set -ouex pipefail`).
- Use `|| true` only for intentional best-effort steps.
- When changing variants or naming, update all of:
  - `.github/workflows/build.yml`
  - `README.md`
  - `AGENTS.md`
