set -u -e

# it seems like the environment id and kafka cluster id for the audit log topic are fixed / do not vary across organizations. 
$CONFLUENT environment use env-vy3g0
$CONFLUENT kafka cluster use lkc-xvv1x
$CONFLUENT api-key use $AL_KEY --resource lkc-xvv1x
$CONFLUENT kafka topic consume confluent-audit-log-events 
