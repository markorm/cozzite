#!/bin/bash

set -ouex pipefail

# Use the COSMIC COPR for newer desktop packages.
dnf5 -y copr enable adil192/cosmic-epoch

# Install COSMIC desktop and default COSMIC applications.
dnf5 -y group install cosmic-desktop cosmic-desktop-apps
dnf5 -y copr disable adil192/cosmic-epoch

# Ensure Noto fonts are present in COSMIC sessions.
dnf5 -y install google-noto-sans-vf-fonts google-noto-sans-mono-vf-fonts google-noto-emoji-fonts

# Prefer COSMIC greeter over GDM where possible.
dnf5 -y remove gdm gnome-shell || true
systemctl enable cosmic-greeter.service -f

# Keep podman socket available (template default).
systemctl enable podman.socket

# Clean package metadata and temp files.
dnf5 clean all
