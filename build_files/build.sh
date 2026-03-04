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

# Rebrand image metadata and MOTD for Cozzite variants.
IMAGE_INFO="/usr/share/ublue-os/image-info.json"
if [[ -f "$IMAGE_INFO" ]]; then
  python3 - "$IMAGE_INFO" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    data = json.load(f)

name_map = {
    "bazzite-gnome": "cozzite",
    "bazzite-gnome-nvidia-open": "cozzite-nvidia",
    "bazzite-dx-gnome": "cozzite-dx",
    "bazzite-dx-nvidia-gnome": "cozzite-dx-nvidia",
}

current_name = data.get("image-name", "")
data["image-name"] = name_map.get(current_name, current_name.replace("bazzite", "cozzite", 1))
data["image-branch"] = "latest"
data["image-tag"] = "latest"

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
fi

cat > /usr/share/ublue-os/motd/bazzite.md <<'EOF'
# Welcome to Cozzite 󰊴
󱋩 `%IMAGE_NAME%:%IMAGE_BRANCH%`
󰟀 `%GREENBOOT%`

|  Command | Description |
| ------- | ----------- |
| `ujust --choose`  | List all available commands |
| `ujust toggle-user-motd` | Toggle this banner on/off |
| `fastfetch` | View system information |
| `brew help` | Manage command line packages |

%TIP%
- **** [Report an issue](http://issues.bazzite.gg/)
- **󰈙** [Documentation](http://docs.bazzite.gg/)
- **󰙯** [Discord](https://discord.bazzite.gg/)
- **** [Bluesky](https://bluesky.bazzite.gg/)
EOF

# Keep podman socket available (template default).
systemctl enable podman.socket

# Clean package metadata and temp files.
dnf5 clean all
