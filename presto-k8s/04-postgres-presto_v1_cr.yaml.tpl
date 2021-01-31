apiVersion: starburstdata.com/v1
kind: Presto
metadata:
  name: starburst-demo
spec:
  nameOverride: starburst-demo
  service:
    type: LoadBalancer
  memory:
    nodeMemoryHeadroom: 1Gi
  coordinator:
    cpuRequest: ""
    memoryAllocation: ""
  worker:
    count: 2
    prestoWorkerShutdownGracePeriodSeconds: 1
    cpuRequest: ""
    memoryAllocation: ""
  hive:
    googleServiceAccountKeySecretName: starburst-demo-sa-gcs
    internalMetastore:
      image:
        pullPolicy: Always
      internalPostgreSql:
        enabled: true
      memory: 0.5Gi
      cpu: 0.5
  additionalCatalogs:
    postgresql: |
      connector.name=postgresql
      connection-url=jdbc:postgresql://DB_ADDRESS:5432/DB_NAME
      connection-user=DB_USER
      connection-password=DB_PASSWORD
