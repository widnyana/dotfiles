#!/usr/bin/env bash
set -euo pipefail

# List Enabled Services, and Service Accounts from every project on your Google Cloud Platform, 
# and present it on the screen
# 
# (c) 2023 - wid/at/widnyana.web.id


echo "Begin listing project(s) and it's resources..."
echo -e "================================================\n"

for PROJECT in $(\
  gcloud projects list \
  --format="value(projectId)")
do
  echo "[+] Project Name: ${PROJECT}"
  echo "[>] Used Services:"
  echo -e "---------------------------------"
  gcloud services list --project="${PROJECT}"
  
  echo "[>] Service Accounts"
  for ACCOUNT in $(\
    gcloud iam service-accounts list \
    --project="${PROJECT}" \
    --format="value(email)")
  do
    echo -e "\t[-] Service Account keys: ${ACCOUNT}"
    # gcloud iam service-accounts keys list --iam-account=${ACCOUNT} --project=${PROJECT}
  done

echo -e "================================================\n\n"

done

