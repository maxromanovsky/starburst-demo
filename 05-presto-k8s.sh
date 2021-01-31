#!/usr/bin/env bash
set -x
kubectl create ns presto
kubectl apply -f presto-k8s/original/presto_v1_crd.yaml
kubectl apply -n presto -f presto-k8s/original/service_account.yaml
kubectl apply -n presto -f presto-k8s/original/role.yaml
kubectl apply -n presto -f presto-k8s/original/role_binding.yaml
kubectl apply -n presto -f presto-k8s/original/operator.yaml

cat presto-k8s/01-initial-presto_v1_cr.yaml

kubectl apply -n presto -f presto-k8s/01-initial-presto_v1_cr.yaml
