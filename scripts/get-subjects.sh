# /bin/bash

set -u -e

TOKEN=$(./get-token.sh | jq -r .access_token)
# echo "Retrieved token: $TOKEN"

curl --request GET ${SCHEMA_REGISTRY_URL}/subjects/ \
  --header 'Confluent-Identity-Pool-Id: '${IDENTITY_POOL_ID} \
  --header 'target-sr-cluster: '${SR_LOGICAL_CLUSTER_ID} \
  --header 'Authorization: Bearer '${TOKEN}

