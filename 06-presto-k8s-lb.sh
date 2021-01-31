#!/usr/bin/env bash
set -x

diff -U3 presto-k8s/01-initial-presto_v1_cr.yaml presto-k8s/02-lb-presto_v1_cr.yaml

kubectl apply -n presto -f presto-k8s/02-lb-presto_v1_cr.yaml
