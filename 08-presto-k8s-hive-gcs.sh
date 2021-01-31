#!/usr/bin/env bash
set -x

kubectl create -n presto secret generic starburst-demo-sa-gcs --from-file=./key.json

diff -U3 presto-k8s/02-lb-presto_v1_cr.yaml presto-k8s/03-gcs-presto_v1_cr.yaml

kubectl apply -n presto -f presto-k8s/03-gcs-presto_v1_cr.yaml
