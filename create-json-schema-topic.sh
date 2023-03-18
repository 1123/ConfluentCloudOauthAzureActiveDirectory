$CONFLUENT kafka topic create json-schema-topic \
  --partitions 6 \
  --cluster $LOGICAL_CLUSTER_ID \
  --environment $ENVIRONMENT
