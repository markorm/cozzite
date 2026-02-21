#!/bin/bash

set -ouex pipefail

# Install COSMIC desktop and default COSMIC applications.
dnf5 -y group install cosmic-desktop cosmic-desktop-apps

# Install Ghostty from COPR.
dnf5 -y copr enable scottames/ghostty
dnf5 -y install ghostty
dnf5 -y copr disable scottames/ghostty

# Install VS Code from the official Microsoft repository.
rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat > /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
dnf5 -y install code

# Install latest OpenCode binary.
curl -fsSL \
  https://github.com/anomalyco/opencode/releases/latest/download/opencode-linux-x64.tar.gz \
  -o /tmp/opencode.tar.gz
tar -xzf /tmp/opencode.tar.gz -C /usr/bin opencode
chmod 0755 /usr/bin/opencode
chown root:root /usr/bin/opencode

# Prefer COSMIC greeter over GDM where possible.
dnf5 -y remove gdm gnome-shell || true
systemctl enable cosmic-greeter.service -f

# Keep podman socket available (template default).
systemctl enable podman.socket

# Clean package metadata and temp files.
dnf5 clean all
rm -f /tmp/opencode.tar.gz
