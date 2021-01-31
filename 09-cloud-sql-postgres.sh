#!/usr/bin/env bash
set -x

gcloud services enable sqladmin.googleapis.com
gcloud sql instances create $GCP_SQL_INSTANCE_NAME --region=$CLOUDSDK_COMPUTE_REGION --database-version=POSTGRES_12 --tier db-f1-micro
gcloud sql instances patch $GCP_SQL_INSTANCE_NAME --authorized-networks=0.0.0.0/0 --quiet
gcloud sql users set-password postgres --instance=$GCP_SQL_INSTANCE_NAME --password=$GCP_SQL_DB_PASSWORD
gcloud sql databases create $GCP_SQL_DB_NAME --instance=$GCP_SQL_INSTANCE_NAME
