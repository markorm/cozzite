# Cozzite

Cozzite is a family of custom Bazzite-derived bootc images that replace the GNOME login/session default with COSMIC.

Each base Cozzite image follows the same minimal customization model:

- install `cosmic-desktop` and `cosmic-desktop-apps`
- ensure Noto Sans/mono/emoji fonts are present
- remove `gdm` and `gnome-shell` (best-effort)
- enable `cosmic-greeter.service`

## Variant matrix

| Image | Upstream base (`latest`) | Branch | Notes |
| --- | --- | --- | --- |
| `cozzite` | `ghcr.io/ublue-os/bazzite-gnome:latest` | `main` | Primary base image |
| `cozzite-nvidia` | `ghcr.io/ublue-os/bazzite-gnome-nvidia-open:latest` | `cozzite-nvidia` | NVIDIA Open variant |
| `cozzite-dx` | `ghcr.io/ublue-os/bazzite-dx-gnome:latest` | `cozzite-dx` | DX GNOME variant |
| `cozzite-dx-nvidia` | `ghcr.io/ublue-os/bazzite-dx-gnome-nvidia-open:latest` | `cozzite-dx-nvidia` | DX + NVIDIA Open variant |
| `cozzite-personal` | `ghcr.io/markorm/cozzite-dx-nvidia:latest` | `cozzite-personal` | Personal spin (`micro`, `ghostty`, `btop`) |

## Rebase commands

Pick the image you want and run:

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/markorm/cozzite:latest
```

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/markorm/cozzite-nvidia:latest
```

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/markorm/cozzite-dx:latest
```

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/markorm/cozzite-dx-nvidia:latest
```

After rebasing:

```bash
systemctl reboot
```

## Build and release flow

- Container publishing is defined in `.github/workflows/build.yml`.
- The workflow builds all base Cozzite variants from a matrix.
- Triggers: push/PR on `main`, manual dispatch, and nightly schedule.
- Nightly rebuilds keep Cozzite current with upstream Bazzite `latest` bases.

## Local development

- Default local target image: `cozzite`
- Build locally: `just build`
- Lint shell scripts: `just lint`
- Validate Justfile syntax: `just check`
