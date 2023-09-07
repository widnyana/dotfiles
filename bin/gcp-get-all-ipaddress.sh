#!/usr/bin/env bash

PROJECTS=$(gcloud projects list --format="value(project_id)" | sort | uniq)

for project in $PROJECTS
do
    if [[ $(gcloud services list --project $project --format="table(NAME)" | sed '1d') =~ "compute.googleapis.com" ]];then
       echo "Project: $project"
       gcloud compute addresses list --project $project
       gcloud compute addresses list --project $project --global
       echo -e "--------------------------------------------------------\n\n"
    fi
done

