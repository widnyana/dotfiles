#!/usr/bin/env bash
# List API keys from Google Cloud Platform, and present it as CSV output 
# on the screen
# 
# (c) 2023 - wid/at/widnyana.web.id

set -euo pipefail

PROJECTID=${1:-none}
if [[ ${PROJECTID} == "none" ]]; then
    echo "usage: $(basename $0) <PROJECTID>"
    exit 1
fi


csvFormat="displayName,name,createTime,updateTime"

CUK=$(gcloud alpha services api-keys list --project="${PROJECTID}" --format="value(uid)")
echo -e "$csvFormat,api-key"
for AK in $CUK;
do
    descr=$(gcloud alpha services api-keys --project="${PROJECTID}" describe $AK --format="csv($csvFormat)" | awk 'NR>1')
    apikey=$(gcloud alpha services api-keys --project="${PROJECTID}" get-key-string $AK | cut -c 12-)

    echo -e "$descr,$apikey"
done