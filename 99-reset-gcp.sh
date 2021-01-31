#!/usr/bin/env bash
set -x

rm key.json



GCP_SA_GCS_FULL_NAME=${GCP_GCS_SA}@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com

gcloud iam service-accounts delete $GCP_SA_GCS_FULL_NAME --quiet

gsutil rm -r gs://${GCP_GCS_BUCKET}

gcloud sql instances delete $GCP_SQL_INSTANCE_NAME --quiet

gcloud container clusters delete $GKE_CLUSTER_NAME --quiet
