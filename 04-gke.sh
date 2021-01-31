#!/usr/bin/env bash
set -x
gcloud services enable container.googleapis.com

gcloud container clusters create $GKE_CLUSTER_NAME --release-channel "regular" --machine-type $GKE_INSTANCE_TYPE \
  --image-type "COS_CONTAINERD" --num-nodes $GKE_NUM_NODES --enable-network-policy --no-enable-ip-alias

kubectl get node
