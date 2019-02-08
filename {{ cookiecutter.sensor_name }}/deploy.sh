#!bin/env bash

export SENSOR=${1:-"{{ cookiecutter.sensor_name }}"}

echo "Deploy ES template:"
curl -u $ELASTIC_USER:$ELASTIC_PASSWORD -X POST $ELASTICMASTER/_template/${SENSOR}_index -d @elastic.json

echo "Deploy parser config:"
curl -iv -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @parser.json $METRON_REST_URL/api/v1/sensor/parser/config/$SENSOR

echo "Deploy enrichment config:"
curl -iv -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @enrichment.json $METRON_REST_URL/api/v1/sensor/enrichment/config/$SENSOR

echo "Deploy indexing config:"
curl -iv -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @indexing.json $METRON_REST_URL/api/v1/sensor/indexing/config/$SENSOR

echo "Deploy Grok statement"
hdfs dfs -put grok /apps/metron/patterns/$SENSOR || echo "No Grok statement present."

echo "Create Kafka topic"
curl -iv -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @kafka.json $METRON_REST_URL/api/v1/kafka/topic