terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.28.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

resource "confluent_environment" "benedikt-tf" {
   display_name = "benedikt-terraform"
}

resource "confluent_kafka_cluster" "standard" {
  display_name = "benedikt-azure-ad-oauth-demo"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-2"
  standard {}
  environment {
    id = confluent_environment.benedikt-tf.id
  }
}

resource "confluent_identity_provider" "azure" {
  display_name = "benedikt-azure-identity-provider"
  description  = "Azure AD Identity Provider by Benedikt"
  issuer       = "https://login.microsoftonline.com/38c8bc12-4622-49a3-a08d-f10715793c67/v2.0"
  jwks_uri     = "https://login.microsoftonline.com/common/discovery/v2.0/keys"
}

resource "confluent_identity_pool" "example" {
  identity_provider {
    id = confluent_identity_provider.azure.id
  }
  display_name    = "Super ID Pool"
  description     = "This id Pool Comprises all Apps within the AD tenant"
  identity_claim  = "claims.sub"
  filter          = "has(claims.iss)"
}

resource "confluent_service_account" "topic-manager" {
  display_name = "topic-manager"
  description  = "Service account to manage topics"
}

resource "confluent_role_binding" "topic-manager-kafka-cluster-admin" {
  principal   = "User:${confluent_service_account.topic-manager.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.standard.rbac_crn
}

resource "confluent_api_key" "topic-manager-kafka-api-key" {
  display_name = "topic-management-api-key"
  description  = "Kafka API Key to manage topics"
  owner {
    id          = confluent_service_account.topic-manager.id
    api_version = confluent_service_account.topic-manager.api_version
    kind        = confluent_service_account.topic-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.standard.id
    api_version = confluent_kafka_cluster.standard.api_version
    kind        = confluent_kafka_cluster.standard.kind

    environment {
      id = confluent_environment.benedikt-tf.id
    }
  }

  depends_on = [
    confluent_role_binding.topic-manager-kafka-cluster-admin
  ]
}

resource "confluent_role_binding" "super-id-pool-developer-write-t1" {
  principal   = "User:${confluent_identity_pool.example.id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${confluent_kafka_topic.t1.topic_name}"
}

resource "confluent_role_binding" "super-id-pool-developer-write-json-schema-topic" {
  principal   = "User:${confluent_identity_pool.example.id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${confluent_kafka_topic.json-schema-topic.topic_name}"
}

resource "confluent_kafka_topic" "t1" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name       = "t1"
  partitions_count = 6
  rest_endpoint    = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.topic-manager-kafka-api-key.id
    secret = confluent_api_key.topic-manager-kafka-api-key.secret
  }
}

resource "confluent_kafka_topic" "json-schema-topic" {
  kafka_cluster {
    id = confluent_kafka_cluster.standard.id
  }
  topic_name       = "json-schema-topic"
  partitions_count = 6
  rest_endpoint    = confluent_kafka_cluster.standard.rest_endpoint
  credentials {
    key    = confluent_api_key.topic-manager-kafka-api-key.id
    secret = confluent_api_key.topic-manager-kafka-api-key.secret
  }
}
