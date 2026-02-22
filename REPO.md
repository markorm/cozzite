# REPO.md

Maintainer notes for the `cozzite-personal` branch.

## Purpose

`cozzite-personal` is built from `ghcr.io/markorm/cozzite-dx-nvidia:latest` and layers personal packages on top:

- `ghostty`
- `micro`

## Baseline behavior to preserve

- install `cosmic-desktop` and `cosmic-desktop-apps`
- ensure Noto Sans/mono/emoji fonts are installed
- remove `gdm` and `gnome-shell` (best-effort)
- enable `cosmic-greeter.service`

## Key files

- `Containerfile`
- `build_files/build.sh`
- `.github/workflows/build.yml`
- `README.md`

## Build workflow

- `build.yml` publishes `ghcr.io/<owner>/cozzite-personal`
- trigger branches: `cozzite-personal`
- nightly schedule is enabled to keep in sync with upstream base

## Local commands

- `just check`
- `just lint`
- `just build`
