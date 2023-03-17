#!/bin/bash

set -u -e

$CONFLUENT iam rbac role-binding create \
  --principal User:$IDENTITY_POOL_ID \
  --role DeveloperRead \
  --resource Topic:t1 \
  --environment $ENVIRONMENT \
  --kafka-cluster-id $LOGICAL_CLUSTER_ID

