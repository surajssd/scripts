#!/bin/bash

set -euo pipefail

sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf -y install http://repo.linrunner.de/fedora/tlp/repos/releases/tlp-release.fc"$(rpm -E %fedora)".noarch.rpm
sudo dnf -y install tlp akmod-tp_smapi akmod-acpi_call kernel-devel
