# Cozzite ISO VM Install Guide

This document covers building the Cozzite ISO locally and testing installation in a VM.

## 1) Prerequisites

- Fedora Atomic/Bazzite host with working `podman` and `just`.
- Hardware virtualization enabled (`/dev/kvm` available).
- Sufficient free disk space (at least 30-40 GB free is recommended).
- Network access from the VM to `ghcr.io` during installation.

## 2) Build the local image

```bash
just build localhost/cozzite-nvidia-open latest
```

This creates the OCI image that the ISO build process uses.

## 3) Build the ISO artifact

```bash
just build-iso localhost/cozzite-nvidia-open latest
```

Expected output:

- `output/bootiso/install.iso`

Quick check:

```bash
ls -lh output/bootiso/install.iso
```

## 4) Run the ISO in the helper VM

Use the built-in VM helper recipe:

```bash
just run-vm-iso localhost/cozzite-nvidia-open latest
```

What it does:

- Starts a QEMU container with KVM acceleration.
- Exposes a local web console on an available localhost port.
- Prints a URL like `http://localhost:8006`.

Open the URL in your browser and use the web console to complete install.

## 5) Walk through the installer

Inside the installer:

1. Select language/region.
2. Open **Installation Destination** and pick the virtual disk.
3. Confirm any required storage defaults.
4. Set user/account options if prompted.
5. Begin installation and wait for completion.
6. Reboot when prompted.

The kickstart `%post` in `disk_config/iso.toml` runs:

```text
bootc switch --mutate-in-place --transport registry ghcr.io/markorm/cozzite-nvidia-open:latest
```

So the VM must be able to reach that registry image.

## 6) First-boot verification in the VM

After booting into the installed system, verify key packages:

```bash
rpm -q cosmic-session cosmic-greeter ghostty code zed
```

Verify `opencode` is present:

```bash
command -v opencode
```

Optional session/service checks:

```bash
systemctl status display-manager.service --no-pager
readlink -f /etc/systemd/system/display-manager.service
```

Expected display-manager target:

- `/usr/lib/systemd/system/cosmic-greeter.service`

## 7) Troubleshooting

- If ISO build fails, run:
  - `just check`
  - `just lint`
- If install fails during `%post`, confirm the target GHCR image exists and is accessible.
- If the VM console is blank, verify KVM access and restart `just run-vm-iso`.
- If package resolution fails during image build, test specific packages with:
  - `sudo podman run --rm ghcr.io/ublue-os/bazzite-gnome-nvidia-open:latest dnf5 repoquery <package>`
