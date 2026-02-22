#!/bin/bash

set -ouex pipefail

# Install COSMIC desktop and default COSMIC applications.
dnf5 -y group install cosmic-desktop cosmic-desktop-apps

# Ensure Noto fonts are present in COSMIC sessions.
dnf5 -y install google-noto-sans-vf-fonts google-noto-sans-mono-vf-fonts google-noto-emoji-fonts

# Personal package set.
dnf5 -y copr enable scottames/ghostty
dnf5 -y install ghostty micro
dnf5 -y copr disable scottames/ghostty

# Prefer COSMIC greeter over GDM where possible.
dnf5 -y remove gdm gnome-shell || true
systemctl enable cosmic-greeter.service -f

# Keep podman socket available (template default).
systemctl enable podman.socket

# Clean package metadata and temp files.
dnf5 clean all
