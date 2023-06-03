#!/usr/bin/env bash
set -euo pipefail

LATEST_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
INSTALL_PATH="${HOME}/.local/bin/kubectl"

echo -e "${LIGHTGREEN}[+] Installing kubectl version${NC} ${LIGHTCYAN}${LATEST_VERSION}${NC}"
curl -LO "https://dl.k8s.io/release/${LATEST_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ${INSTALL_PATH}

echo -e "[+] kubectl installed to ${CYAN}${INSTALL_PATH}${NC}\n\n"