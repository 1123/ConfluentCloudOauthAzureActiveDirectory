#!/bin/bash

set -u -e
 
# This does not work. Producing via oauth authentication only works directly
# with the java client libraries. 

set -x

$BINARIES/kafka-json-schema-console-producer \
  --bootstrap-server $BOOTSTRAP_SERVERS \
  --producer.config azure-ad-client.properties \
  --property value.schema='{"type":"object","properties":{"f1":{"type":"string"}}}' \
  --property schema.registry.url=$SCHEMA_REGISTRY_URL \
  --property schema.registry.bearer.auth.credentials.source=OAUTHBEARER \
  --property schema.registry.bearer.auth.logical.cluster=$SR_LOGICAL_CLUSTER_ID \
  --property schema.registry.bearer.auth.issuer.endpoint.url=https://login.microsoftonline.com/$AZURE_TENANT/oauth2/v2.0/token \
  --property schema.registry.bearer.auth.client.id=$CLIENT_ID \
  --property schema.registry.bearer.auth.scope=$CLIENT_ID/.default \
  --property schema.registry.bearer.auth.client.secret=$CLIENT_SECRET \
  --property schema.registry.bearer.auth.identity.pool.id=$IDENTITY_POOL_ID \
  --topic json-schema-topic

set +x
