set -u -e

TOKEN=$(./get-token.sh | jq -r .access_token)

curl \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Confluent-Identity-Pool-Id: $IDENTITY_POOL_ID" \
  -H "Authorization: Bearer $TOKEN" \
  https://$REST_BOOTSTRAP_SERVERS:443/kafka/v3/clusters/$LOGICAL_CLUSTER_ID/topics \
  -d '{"topic_name":"t1"}'
