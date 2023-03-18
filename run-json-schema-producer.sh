# This does not work. Producing via oauth authentication only works directly
# with the java client libraries. 

$BINARIES/kafka-json-schema-console-producer \
  --bootstrap-server $BOOTSTRAP_SERVERS \
  --producer.config azure-ad-client.properties \
  --property value.schema='{"type":"object","properties":{"f1":{"type":"string"}}}' \
  --topic json-schema-topic
