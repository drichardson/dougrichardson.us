#!/bin/bash

set -xeuo pipefail
shopt -s inherit_errexit

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source "$SCRIPTPATH/../globals.sh"

# Only need to do this once"
# echo "Reserving Static IP Address..."
# gcloud compute --project addresses create $ADDRESS_NAME

echo Retreiving address...
IP_ADDRESS=$(gcloud --format 'value(address)' compute addresses describe $ADDRESS_NAME --region $CLOUDSDK_COMPUTE_REGION)
echo Static IP address $ADDRESS_NAME is $IP_ADDRESS

# Build the startup script
STARTUP_SCRIPT=$(mktemp)
./build-startup-script.sh > "$STARTUP_SCRIPT"

gcloud compute instances create $INSTANCE_NAME \
    --machine-type f1-micro \
    --subnet $SUBNET \
    --maintenance-policy MIGRATE \
    --no-service-account --no-scopes \
    --tags http-server,https-server,ssh-server \
    --image-family debian-10 --image-project debian-cloud \
    --boot-disk-size 10GB  --boot-disk-type pd-standard \
    --metadata-from-file startup-script="$STARTUP_SCRIPT" \
    --address $IP_ADDRESS

cat <<EOF
Monitor the progress of the $INSTANCE_NAME instance with:

    gcloud compute instances tail-serial-port-output --project $CLOUDSDK_CORE_PROJECT $INSTANCE_NAME

SSH into the instance with:

    gcloud compute ssh --project=$CLOUDSDK_CORE_PROJECT $INSTANCE_NAME --zone=$CLOUDSDK_COMPUTE_ZONE

Deploy the sites with the deploy.sh scripts in ../www.

website.sh OK
EOF


