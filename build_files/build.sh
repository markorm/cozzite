#!/bin/bash

set -ouex pipefail

# Personal package set.
dnf5 -y copr enable scottames/ghostty
dnf5 -y install ghostty micro
dnf5 -y copr disable scottames/ghostty

# Clean package metadata and temp files.
dnf5 clean all
