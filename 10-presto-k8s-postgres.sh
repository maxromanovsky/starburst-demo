#!/usr/bin/env bash
set -x

diff -U3 presto-k8s/03-gcs-presto_v1_cr.yaml presto-k8s/04-postgres-presto_v1_cr.yaml.tpl

sed "s/DB_ADDRESS/${GCP_SQL_DB_ADDRESS}/g; s/DB_NAME/${GCP_SQL_DB_NAME}/g; s/DB_USER/postgres/g; s/DB_PASSWORD/${GCP_SQL_DB_PASSWORD}/g" \
  presto-k8s/04-postgres-presto_v1_cr.yaml.tpl \
  | tee /dev/tty | kubectl apply -n presto -f -
