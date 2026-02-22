# Cozzite

Cozzite is a family of custom Bazzite-derived bootc images that replace the GNOME login/session default with COSMIC.

Each base Cozzite image keeps a minimal customization model:

- install `cosmic-desktop` and `cosmic-desktop-apps`
- ensure Noto Sans/mono/emoji fonts are present
- remove `gdm` and `gnome-shell` (best-effort)
- enable `cosmic-greeter.service`

## Available images

| Image | Upstream base (`latest`) | Branch | Notes |
| --- | --- | --- | --- |
| `cozzite` | `ghcr.io/ublue-os/bazzite-gnome:latest` | `main` | Primary base image |
| `cozzite-nvidia` | `ghcr.io/ublue-os/bazzite-gnome-nvidia-open:latest` | `cozzite-nvidia` | NVIDIA Open variant |
| `cozzite-dx` | `ghcr.io/ublue-os/bazzite-dx-gnome:latest` | `cozzite-dx` | DX GNOME variant |
| `cozzite-dx-nvidia` | `ghcr.io/ublue-os/bazzite-dx-nvidia-gnome:latest` | `cozzite-dx-nvidia` | DX + NVIDIA variant |

`cozzite-personal` is a separate branch/image (`cozzite-personal`) based on `cozzite-dx-nvidia`.

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

## Verify the rebase

```bash
rpm-ostree status
```

You should see the selected `ghcr.io/markorm/cozzite*` image in the booted deployment.

If you need to roll back to the previous deployment:

```bash
sudo rpm-ostree rollback
systemctl reboot
```

---

Repository/maintainer instructions are documented in `REPO.md`.
