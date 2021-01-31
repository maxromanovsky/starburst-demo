#!/usr/bin/env bash
# https://docs.starburstdata.com/latest/kubernetes/deployment.html

rm -fv presto-k8s/original/*
wget -P presto-k8s/original/ https://starburstdata.s3.us-east-2.amazonaws.com/k8s/${SEP_K8S_VERSION}/service_account.yaml
wget -P presto-k8s/original/ https://starburstdata.s3.us-east-2.amazonaws.com/k8s/${SEP_K8S_VERSION}/role.yaml
wget -P presto-k8s/original/ https://starburstdata.s3.us-east-2.amazonaws.com/k8s/${SEP_K8S_VERSION}/role_binding.yaml
wget -P presto-k8s/original/ https://starburstdata.s3.us-east-2.amazonaws.com/k8s/${SEP_K8S_VERSION}/presto_v1_crd.yaml
wget -P presto-k8s/original/ https://starburstdata.s3.us-east-2.amazonaws.com/k8s/${SEP_K8S_VERSION}/operator.yaml
wget -P presto-k8s/original/ https://starburstdata.s3.us-east-2.amazonaws.com/k8s/${SEP_K8S_VERSION}/example_presto_v1_cr.yaml
