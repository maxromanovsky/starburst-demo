# Starburst on GKE demo

## Preparation
### Install of required software
#### macOS
[`01-prepare-macos.sh`](./01-prepare-macos.sh)

### Verify software versions used in the demo
#### macOS
[`02-check-versions-macos.sh`](./02-check-versions-macos.sh)

```
macOS: 11.1
bash: GNU bash, version 5.1.4(1)-release (x86_64-apple-darwin20.2.0)
python: Python 3.9.1
kubectl: Client Version: v1.20.2
presto: Presto CLI 344

java:
openjdk version "15.0.2" 2021-01-19
OpenJDK Runtime Environment AdoptOpenJDK (build 15.0.2+7)
OpenJDK 64-Bit Server VM AdoptOpenJDK (build 15.0.2+7, mixed mode, sharing)

gcloud:
Google Cloud SDK 325.0.0
beta 2021.01.22
bq 2.0.64
core 2021.01.22
gsutil 4.58
```

### Create new GCP Project
https://console.cloud.google.com/cloud-resource-manager

### Prepare environment variables

```bash
# https://cloud.google.com/sdk/docs/properties#setting_properties_via_environment_variables
export CLOUDSDK_CORE_ACCOUNT=example@gmail.com
export CLOUDSDK_CORE_PROJECT=starburst-demo
export CLOUDSDK_COMPUTE_REGION=europe-west4 #Netherlands
export CLOUDSDK_COMPUTE_ZONE=europe-west4-a

# https://cloud.google.com/compute/docs/machine-types#machine_types
# https://cloud.google.com/compute/vm-instance-pricing#n1_standard_machine_types
# n1-standard-4 4vCPU, 15GB RAM, $0.2092/hour in europe-west4 (Netherlands)
export GKE_INSTANCE_TYPE=n1-standard-4
export GKE_CLUSTER_NAME=starburst-demo-cluster
export GKE_NUM_NODES=3

export GCP_GCS_SA=starburst-gcs
export GCP_GCS_BUCKET=starburst-demo

# Version of k8s descriptors from https://docs.starburstdata.com/latest/kubernetes/deployment.html
export SEP_K8S_VERSION=348-e-k8s-0.52

export GCP_SQL_INSTANCE_NAME=starburst-demo-sql
export GCP_SQL_DB_NAME=starburst
export GCP_SQL_DB_PASSWORD=starburstpwd
```

Tip: `.env` files can be used:
```bash
source .env
```

### Init gcloud CLI
[`03-init.sh`](./03-init.sh)

## Provision GKE cluster
[`04-gke.sh`](./04-gke.sh)

Check that all nodes are ready:
```bash
kubectl get node
```

[![asciicast](https://asciinema.org/a/TO20JrbYzCWkLGxVF0VgOEjFN.svg)](https://asciinema.org/a/TO20JrbYzCWkLGxVF0VgOEjFN)

## Install SEP
[`05-presto-k8s.sh`](./05-presto-k8s.sh)

Wait until all SEP pods are up and running:
```bash
watch -n5 kubectl get pod -n presto
```

[![asciicast](https://asciinema.org/a/sxvN4P2KbPBqaWMMTtI4rttA4.svg)](https://asciinema.org/a/sxvN4P2KbPBqaWMMTtI4rttA4)

## Expose SEP via LoadBalancer
[`06-presto-k8s-lb.sh`](./06-presto-k8s-lb.sh)

Wait until LoadBalancer is deployed:
```bash
watch -n5 kubectl get svc presto-coordinator-starburst-demo -n presto
```

Launch browser with the LoadBalancer IP (use an arbitrary username):
```bash
kubectl get svc presto-coordinator-starburst-demo -n presto -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

export PRESTO_IP=`kubectl get svc presto-coordinator-starburst-demo -n presto -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
echo $PRESTO_IP
open "http://${PRESTO_IP}:8080"
```

[![asciicast](https://asciinema.org/a/KsZXiMjHyo0PwyOMBtyQJ8AKg.svg)](https://asciinema.org/a/KsZXiMjHyo0PwyOMBtyQJ8AKg)

## Add GCS (object storage) leveraging Hive connector

### Create GCS bucket and service account
[`07-gcs.sh`](./07-gcs.sh)

### Configure Starburst Hive connector
[`08-presto-k8s-hive-gcs.sh`](./08-presto-k8s-hive-gcs.sh)

Wait until all SEP pods are up and running again:
```bash
watch -n5 kubectl get pod -n presto
```

[![asciicast](https://asciinema.org/a/N1pvsPqhh12jLi9M2mDidZPkv.svg)](https://asciinema.org/a/N1pvsPqhh12jLi9M2mDidZPkv)

## Configure Google Cloud SQL (PostgreSQL)
[`09-cloud-sql-postgres.sh`](./09-cloud-sql-postgres.sh)

Once DB instance provisioned, connection can be established via Public IP (`PRIMARY_ADDRESS`):
```bash
gcloud sql instances list
```
DB config:
- IP: `PRIMARY_ADDRESS`
- Port: `5432`
- Username: `postgres`
- Password: `echo $GCP_SQL_DB_PASSWORD`
- Database: `starburst`

## Configure Starburst PostgreSQL connector

Set PostreSQL IP address as an environment variable:
```bash
export GCP_SQL_DB_ADDRESS=PRIMARY_ADDRESS
```

[`10-presto-k8s-postgres.sh`](./10-presto-k8s-postgres.sh)

Wait until all SEP pods are up and running again:
```bash
watch -n5 kubectl get pod -n presto
```

[![asciicast](https://asciinema.org/a/ILjOIcQqW036g1rQSzH5Dvbmh.svg)](https://asciinema.org/a/ILjOIcQqW036g1rQSzH5Dvbmh)

## Execute queries

### Execute queries via `presto` CLI
```bash
presto --server=${PRESTO_IP}:8080
```

### Initialize tables

#### From Presto CLI

```sql
show catalogs;
show schemas from hive;
USE hive.default;
CREATE TABLE iris
(
    sepal_length_cm double,
    sepal_width_cm  double,
    petal_length_cm double,
    petal_width_cm  double,
    species         varchar(10)
) WITH (
    external_location = 'gs://starburst-demo/iris/',
    format = 'ORC'
);

select * from iris limit 5;
```

[![asciicast](https://asciinema.org/a/tLBf7jNgIDfsLRhmOIPbahGJS.svg)](https://asciinema.org/a/tLBf7jNgIDfsLRhmOIPbahGJS)

#### From DBeaver

```sql
create table iris_species(
    name varchar(10) primary key,
    wiki_url varchar(255)
);

insert into iris_species(name, wiki_url) values
('setosa', 'https://en.wikipedia.org/wiki/Iris_setosa'),
('versicolor', 'https://en.wikipedia.org/wiki/Iris_versicolor'),
('virginica', 'https://en.wikipedia.org/wiki/Iris_virginica');
```

### Run queries

```sql

SELECT histogram( floor(petal_length_cm) )
FROM hive.default.iris;

SELECT floor(petal_length_cm) k, count(*) v
FROM hive.default.iris
GROUP BY 1
ORDER BY 2 DESC;

SELECT map_agg(k, v) FROM (SELECT floor(petal_length_cm) k, count(*) v
                           FROM hive.default.iris
                           GROUP BY 1);


SELECT histogram( floor(i.petal_length_cm) ) x, i.species, s.wiki_url
FROM hive.default.iris i
         join postgresql.public.iris_species s on i.species = s.name
GROUP BY i.species, s.wiki_url;


select * from hive.default.iris i
                  join postgresql.public.iris_species s on i.species = s.name
    limit 5;

```

## Misc

### Housekeeping
[`99-reset-gcp.sh`](./99-reset-gcp.sh)

### Update to new versions of Starburst k8s descriptors
[`00-update-k8s-descriptors.sh`](./00-update-k8s-descriptors.sh)
