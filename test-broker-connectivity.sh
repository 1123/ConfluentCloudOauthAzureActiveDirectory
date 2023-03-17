#!/bin/bash

set -u -e
 
kafka-broker-api-versions \
  --bootstrap-server $BOOTSTRAP_SERVERS \
  --command-config azure-ad-client.properties

