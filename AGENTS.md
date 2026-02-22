# AGENTS.md

## Branch intent

This branch builds `cozzite-personal`, based on `ghcr.io/markorm/cozzite-dx-nvidia:latest`.

Personal additions in this branch:

- `ghostty`
- `micro`

Keep the existing COSMIC baseline behavior:

1. install `cosmic-desktop` and `cosmic-desktop-apps`
2. ensure Noto Sans/mono/emoji fonts are installed
3. remove `gdm` and `gnome-shell` (best-effort)
4. enable `cosmic-greeter.service`

## Files that matter most

- `Containerfile`: default base image for this branch
- `build_files/build.sh`: package set and service changes
- `.github/workflows/build-personal.yml`: publishes `cozzite-personal`
- `README.md`: end-user rebase command

## Quick checks

- `just check`
- `just lint`
- `just build`
