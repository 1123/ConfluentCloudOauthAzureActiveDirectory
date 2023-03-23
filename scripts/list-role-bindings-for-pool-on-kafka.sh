#!/bin/bash

set -u -e

$CONFLUENT iam rbac role-binding list \
  --principal User:$IDENTITY_POOL_ID \
  --environment $ENVIRONMENT_ID \
  --kafka-cluster-id $LOGICAL_CLUSTER_ID

