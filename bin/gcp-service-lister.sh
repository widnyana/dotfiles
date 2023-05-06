#!/usr/bin/env bash
set -euo pipefail

# List Enabled Services, and Service Accounts from every project on your Google Cloud Platform, 
# and present it on the screen
# 
# (c) 2023 - wid/at/widnyana.web.id


PROJECTID=${1:-none}
if [[ ${PROJECTID} == "none" ]]; then
    PROJECTID=$(gcloud projects list --format="value(projectId)")
fi


echo "Begin listing project(s) and it's resources..."
echo -e "================================================\n"

for PROJECT in $PROJECTID
do
  echo "[+] Project Name: ${PROJECT}"
  echo "[>] Enabled Services:"
  gcloud services list --project="${PROJECT}"
  echo -e "---------------------------------\n"
  
  ### Compute Instances
  echo "[>] Compute engine instances:"
  gcloud compute instances list --project="${PROJECT}" \
    --sort-by=name \
    --format="table(zone,\
          name,\
          machineType,\
          status,\
          scheduling.preemptible,\
          scheduling.automaticRestart,\
          networkInterfaces.networkIP:label='Internal IP',\
          networkInterfaces.accessConfigs.natIP:label='External IP'\
        )"
  echo -e "---------------------------------\n"

  ### Compute Disks
  echo "[>] Compute Disks:"
  gcloud compute disks list --project="${PROJECT}" \
    --format="table(\
        id, \
        zone.scope(), \
        name, \
        size_gb, \
        type, \
        status \
        )"

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

