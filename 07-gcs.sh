#!/usr/bin/env bash
set -x
gcloud iam service-accounts create $GCP_GCS_SA

GCP_SA_GCS_FULL_NAME=${GCP_GCS_SA}@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com

gcloud iam service-accounts keys create --iam-account=$GCP_SA_GCS_FULL_NAME key.json
gcloud projects add-iam-policy-binding $CLOUDSDK_CORE_PROJECT --member="serviceAccount:${GCP_SA_GCS_FULL_NAME}" --role='roles/storage.objectAdmin'

gsutil mb -l $CLOUDSDK_COMPUTE_REGION -b on gs://${GCP_GCS_BUCKET}
gsutil cp dataset/iris/* gs://${GCP_GCS_BUCKET}/iris/
