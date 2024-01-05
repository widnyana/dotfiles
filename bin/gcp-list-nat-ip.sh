#!/usr/bin/env bash
set -euo pipefail


PROJECTS=$(gcloud projects list --format="value(project_id)" | sort | uniq | grep -v "sys-")

for project in $PROJECTS
do
    if [[ $(gcloud services list --project $project --format="table(NAME)" | sed '1d') =~ "compute.googleapis.com" ]];then
        echo -e "Listing in project: $project"
        ROUTERS=$(gcloud compute routers list  --format="csv[no-heading](NAME,REGION)" --project=$project)
        for router in $ROUTERS
        do
            IFS=$','; split=($router); unset IFS;
            ROUTER="${split[0]}"
            REGION="${split[1]}"

            NATS=$(gcloud compute routers nats list --router="${ROUTER}" --region="${REGION}" --project="${project}" --format="csv[no-heading](NAME)")
            echo -e "NAT name: ${NATS}"

            for nat in $NATS
            do
                NAT_IPS=$(gcloud compute routers nats describe  natgw-asgard-staging --router="${ROUTER}" --region="${REGION}" --project="${project}" '--format=csv[no-heading](natIps)')

                echo "NAT_IPS: ${NAT_IPS}"

            done
            echo -e "------------------------------------------------------------------------------------------"
        done
    fi
    echo -e "------------------------------------------------------------------------------------------"
    break
done

