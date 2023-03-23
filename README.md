# Confluent Cloud with Azure Active Directory OAuth Client Authentication

This repository provides a working setup of a Confluent Cloud Kafka and Schema Registry cluster 
and client applications that connect via Azure AD Oauth authentication. 

All resources except for the Azure AD tenant and Azure AD Applications are managed by terraform. 
This includes the following Confluent Cloud resources: 

* Confluent Cloud Environment
* Confluent Cloud Kafka Cluster
* Confluent Cloud Topics
* Azure AD Identity Provider on Confluent Cloud
* Azure AD Identity Pools on Confluent Cloud
* Confluent Cloud Service Accounts
* Confluent Cloud Api Keys
* Confluent Cloud Role Bindings
* Confluent Cloud Schema Registry Cluster

## Prerequisites

* Linux or Mac Environment
* A recent version of terraform command line interface installed
* A Confluent Cloud Account with OrganizationAdmin privileges
* Confluent command line interface tools installed for testing purposes 
  * `kafka-console-producer` 
  * `kafka-json-schema-console-producer`
  * `kafka-broker-api-versions`
  * `confluent cloud cli`
  * `kafka-topics`
* `curl` for direct interaction with the confluent cloud API. 
* For running the Java Test Client: 
  * a recent version of Java (JDK)
  * a recent version of Apache Maven

## Setting up the environment

* `cd terraform`
* Create a service account for terraform with OrganizationAdmin privileges
* Create an API key for the above service account
* export your api key and api secret as environment variables for terraform:

```
export TF_VAR_confluent_cloud_api_key=...
export TF_VAR_confluent_cloud_api_secret=...
```
* run `terraform init`
* run `terraform apply`. Take note of the outputs (e.g. ENVIRONMENT_ID, BOOTSTRAP_SERVERS, IDENTITY_POOL_ID)

## Testing your Setup

* make a copy of sample.env file (e.g. `john.env`)
* adjust variables in `john.env` using the terraform outputs from above
* source your environment `source john.env`
* run `./create-properties-files.sh` to create the azure-ad-client.properties file.
* `cd scripts`
* Test producing data without a schema with Ouath authentication `./run-producer.sh`
* Test producing data with a json-schema schema to be registered in Cloud Schema Registry: `./run-json-schema-producer.sh`

## Running the Java App

* run `./create-properties-files.sh` to create the `java-test-client/src/main/resources/client.properties` file
* import the Java project in the `java-test-client/` subdirectory into your favorite Java IDE
* run the `SampleProducer` application from within your IDE or from the command line. 
* Verify that data is written to the `person-topic` topic through the Confluent Cloud UI. 


