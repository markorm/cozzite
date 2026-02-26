# AGENTS.md

## Branch intent

This branch builds `cozzite-personal`, based on `ghcr.io/markorm/cozzite-dx-nvidia:latest`.

Personal additions in this branch:

- `ghostty`
- `micro`

`ghcr.io/markorm/cozzite-dx-nvidia:latest` already provides the COSMIC baseline.

Keep this branch additive-only:

1. install personal packages (`ghostty`, `micro`)
2. avoid reapplying base COSMIC setup steps from `main`

## Files that matter most

- `Containerfile`: default base image for this branch
- `build_files/build.sh`: package set and service changes
- `.github/workflows/build-personal.yml`: publishes `cozzite-personal`
- `README.md`: end-user rebase command

## Quick checks

- `just check`
- `just lint`
- `just build`
