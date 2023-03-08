#!/usr/bin/env bash
set -euo pipefail
source ~/.dotfiles/common/colors

REPO="aquasecurity/trivy"
URL=$(curl -sSL https://api.github.com/repos/${REPO}/releases/latest | awk -F\" '/browser_download_url.*Linux-64bit.tar.gz"/{print $(NF-1)}')
FILENAME=$(basename -- $URL)

echo -e "Downloading ${BROWN}$URL${NC} to ${BROWN}$FILENAME${NC} ..."
rm -fr "${FILENAME}"
wget -q $URL -O $FILENAME --show-progress

echo -e "Extracting ${BROWN}$FILENAME${NC} ..."
tar zxvf $FILENAME
rm -fr README.md LICENSE "${FILENAME}"
mv contrib trivy-contrib
echo -e "${PURPLE}Done!${NC}"