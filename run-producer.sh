kafka-console-producer \
  --producer-property 'security.protocol=SASL_SSL' \
  --producer-property sasl.oauthbearer.token.endpoint.url=https://login.microsoftonline.com/$AZURE_TENANT/oauth2/v2.0/token \
  --producer-property sasl.login.callback.handler.class=org.apache.kafka.common.security.oauthbearer.secured.OAuthBearerLoginCallbackHandler \
  --producer-property sasl.mechanism=OAUTHBEARER \
  --producer-property "sasl.jaas.config=org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required clientId='$CLIENT_ID' scope='$CLIENT_ID/.default' clientSecret='$CLIENT_SECRET' extension_logicalCluster='$LOGICAL_CLUSTER_ID' extension_identityPoolId='$IDENTITY_POOL_ID';" \
  --bootstrap-server $BOOTSTRAP_SERVERS \
  --topic t1

