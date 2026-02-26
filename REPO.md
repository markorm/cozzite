# REPO.md

Maintainer notes for the `cozzite-personal` branch.

## Purpose

`cozzite-personal` is built from `ghcr.io/markorm/cozzite-dx-nvidia:latest` and layers personal packages on top:

- `ghostty`
- `micro`

## Layering model

- `ghcr.io/markorm/cozzite-dx-nvidia:latest` provides the COSMIC baseline behavior.
- Keep this branch additive-only: install personal packages and avoid duplicating base COSMIC setup steps.

## Key files

- `Containerfile`
- `build_files/build.sh`
- `.github/workflows/build-personal.yml`
- `README.md`

## Build workflow

- `build-personal.yml` publishes `ghcr.io/<owner>/cozzite-personal`
- trigger branches: `cozzite-personal`
- nightly schedule is enabled to keep in sync with upstream base

## Local commands

- `just check`
- `just lint`
- `just build`
