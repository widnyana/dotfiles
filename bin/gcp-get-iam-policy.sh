#!/usr/bin/env bash
#──────────────────────────────────────────────────────────────────────────────
# Damarseta · Infrastructure with Intent. Aligned. Reliable.
# Copyright (c) 2025 wid@damarseta.id · https://damarseta.id
#──────────────────────────────────────────────────────────────────────────────
# Context: gcp
# Purpose: Show IAM policy bindings for a service account in a GCP project

# Show IAM policy bindings for a given service account in a GCP project
#
# (c) 2023 - wid/at/widnyana.web.id

set -euo pipefail

usage() {
    echo -e "usage: $(basename $0) <PROJECTID> <SERVICE ACCOUNT>"
    echo -e "example:"
    echo -e "\t $(basename $0) \"flying-cow-1245\" \"12315124312-compute@flying-cow-1245.iam.gserviceaccount.com\""
}

PROJECTID=${1:-none}
if [[ ${PROJECTID} == "none" ]]; then
    usage
    exit 1
fi

SERVICE_ACCOUNT=${2:-none}
if [[ ${SERVICE_ACCOUNT} == "none" ]]; then
    usage
    exit 1
fi


gcloud projects get-iam-policy "${PROJECTID}" \
    --flatten="bindings[].members" \
    --format='table(bindings.role, etag, version)' \
    --filter="bindings.members:${SERVICE_ACCOUNT}"
# --format='table(bindings.role)'