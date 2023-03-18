$CONFLUENT iam rbac role-binding list \
  --principal User:$IDENTITY_POOL_ID \
  --environment $ENVIRONMENT
