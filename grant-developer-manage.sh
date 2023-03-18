#!/bin/bash

set -u -e

$CONFLUENT iam rbac role-binding create \
  --principal User:$IDENTITY_POOL_ID \
  --role DeveloperManage \
  --resource Topic:t1 \
  --environment $ENVIRONMENT \
  --kafka-cluster-id $LOGICAL_CLUSTER_ID

$CONFLUENT iam rbac role-binding create \
  --principal User:$IDENTITY_POOL_ID \
  --role DeveloperManage \
  --resource Topic:json-schema-topic \
  --environment $ENVIRONMENT \
  --kafka-cluster-id $LOGICAL_CLUSTER_ID
