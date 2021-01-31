# Starburst on GKE demo

## Preparation
### macOS
[`01-prepare-macos.sh`](./01-prepare-macos.sh)

## Software versions used in the demo
### macOS
[`02-check-versions-macos.sh`](./02-check-versions-macos.sh)

```
macOS: 11.1
bash: GNU bash, version 5.1.4(1)-release (x86_64-apple-darwin20.2.0)
python: Python 3.9.1

gcloud:
Google Cloud SDK 325.0.0
beta 2021.01.22
bq 2.0.64
core 2021.01.22
gsutil 4.58
```

## Create new GCP Project
https://console.cloud.google.com/cloud-resource-manager

## Prepare environment variables

Tip: `.env` files can be used if shell support is enabled. 

```bash
# https://cloud.google.com/sdk/docs/properties#setting_properties_via_environment_variables
export CLOUDSDK_CORE_ACCOUNT=example@gmail.com
export CLOUDSDK_CORE_PROJECT=starburst-demo
export CLOUDSDK_COMPUTE_ZONE=europe-west4-a #Netherlands 
```
