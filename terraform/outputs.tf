output "IDENTITY_POOL_ID" {
  description = "Id of the identity pool comprising all apps"
  value = confluent_identity_pool.all_identities.id
}

output "ENVIRONMENT_ID" {
  description = "Environment Id"
  value = confluent_environment.benedikt-tf.id
}

output "LOGICAL_CLUSTER_ID" {
  description = "Identifier for the logical Kafka cluster"
  value = confluent_kafka_cluster.standard.id
}

output "BOOTSTRAP_SERVERS" {
  description = "Bootstrap Servers of Kafka Cluster"
  value = confluent_kafka_cluster.standard.bootstrap_endpoint
}

output "api-key" {
  description = "API Key for the topic manager service account"
  value       = confluent_api_key.topic-manager-kafka-api-key.id
}

output "api-secret" {
  description = "API Secret for the topic manager service account"
  sensitive = true
  value       = confluent_api_key.topic-manager-kafka-api-key.secret
}

output "SCHEMA_REGISTRY_URL" {
  description = "Schema registry url"
  value = confluent_schema_registry_cluster.essentials.rest_endpoint
}

output "SR_LOGICAL_CLUSTER_ID" {
  description = "Identifier of the logical schema registry cluster"
  value = confluent_schema_registry_cluster.essentials.id
}
