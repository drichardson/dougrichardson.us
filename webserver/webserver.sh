#!/bin/bash

set -e

REGION=us-central1
ZONE=us-central1-d
PROJECT=doug-richardson
ADDRESS_NAME=webserver
INSTANCE_NAME=webserver

# Only need to do this once"
# echo "Reserving Static IP Address..."
# gcloud compute --project $PROJECT addresses create $ADDRESS_NAME --region $REGION

echo "Retreiving address..."
IP_ADDRESS=$(gcloud --format 'value(address)' compute --project $PROJECT addresses describe $ADDRESS_NAME --region $REGION)
echo "Static IP address $ADDRESS is $IP_ADDRESS"

# Build the startup script
STARTUP_SCRIPT=$(mktemp)
./website/build-startup-script.sh > "$STARTUP_SCRIPT"


gcloud compute --project $PROJECT \
    instances create $INSTANCE_NAME \
    --zone $ZONE \
    --machine-type "f1-micro" \
    --subnet $SUBNET \
    --maintenance-policy "MIGRATE" \
    --no-service-account --no-scopes \
    --tags "$HTTPS_SERVER_FIREWALL_TAG,$HTTP_SERVER_FIREWALL_TAG,$SSH_SERVER_FIREWALL_TAG" \
    --image-family ubuntu-1804-lts --image-project gce-uefi-images \
    --shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring \
    --boot-disk-size 10GB  --boot-disk-type pd-standard \
    --metadata-from-file startup-script="$STARTUP_SCRIPT"
    --address $IP_ADDRESS

cat <<EOF
Monitor the progress of the $INSTANCE_NAME instance with:

    gcloud compute instances tail-serial-port-output --project $PROJECT $INSTANCE_NAME

SSH into the instance with:

    gcloud compute ssh --project=$PROJECT $INSTANCE_NAME

Deplay the sites with the deploy.sh scripts in ../www.

website.sh OK
EOF


