# Does not work for some reason.  
# Error: metadata service backend error: Forbidden Access

$CONFLUENT iam rbac role-binding create \
  --principal User:$IDENTITY_POOL_ID \
  --role DeveloperWrite \
  --resource Subject:json-schema-topic-value \
  --environment $ENVIRONMENT_ID \
  --kafka-cluster-id $LOGICAL_CLUSTER_ID \
  --schema-registry-cluster-id $SR_LOGICAL_CLUSTER_ID
