#!/bin/bash

set -x

for i in {0..2}; do
  cat <<'EOF' | vagrant ssh "controller-${i}" -- sudo bash
set -euo pipefail

echo "192.168.199.23 ubuntu" | sudo tee -a /etc/hosts

EOF
done

for i in {0..2}; do
  cat <<'EOF' | vagrant ssh "worker-${i}" -- sudo bash
set -euo pipefail

echo "192.168.199.23 ubuntu" | sudo tee -a /etc/hosts

EOF
done
