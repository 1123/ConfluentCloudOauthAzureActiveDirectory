#!/bin/bash

set -u -e

$CONFLUENT iam rbac role-binding create \
  --principal User:$IDENTITY_POOL_ID \
  --role DeveloperWrite \
  --resource Topic:json-schema-topic \
  --environment $ENVIRONMENT \
  --kafka-cluster-id $LOGICAL_CLUSTER_ID

