# Cozzite Personal

`cozzite-personal` is a personal spin of Cozzite based on `ghcr.io/markorm/cozzite-dx-nvidia:latest`.

On top of the base Cozzite DX NVIDIA image, this branch adds:

- `ghostty`
- `micro`

## Rebase command

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/markorm/cozzite-personal:latest
```

Then reboot:

```bash
systemctl reboot
```

## Verify

```bash
rpm -q ghostty micro
rpm-ostree status
```

Repository maintainer notes are in `REPO.md`.
