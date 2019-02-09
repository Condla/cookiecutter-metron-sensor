#!bin/env bash

export SENSOR=${1:-"{{ cookiecutter.sensor_name }}"}

echo "########      Deploy ES template       #########"
{% if cookiecutter.elastic_user == "" %}
curl -X POST $ELASTICMASTER/_template/${SENSOR}_index -d @elastic.json
{% else %}
curl -u $ELASTIC_USER:$ELASTIC_PASSWORD -X POST $ELASTICMASTER/_template/${SENSOR}_index -d @elastic.json
{% endif %}
echo \n\n

echo "########      Deploy parser config     #########"
curl -iv -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @parser.json $METRON_REST_URL/api/v1/sensor/parser/config/$SENSOR
echo \n\n


echo "########      Deploy enrichment config #########"
curl -iv -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @enrichment.json $METRON_REST_URL/api/v1/sensor/enrichment/config/$SENSOR
echo \n\n


echo "########      Deploy indexing config   #########"
curl -iv -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @indexing.json $METRON_REST_URL/api/v1/sensor/indexing/config/$SENSOR
echo \n\n


{% if cookiecutter.parser_class_name=="org.apache.metron.parsers.GrokParser" %}
echo "########      Deploy Grok statement    #########"
sudo su metron -c "kinit -kt /etc/security/keytabs/metron.headless.keytab metron"
sudo su metron -c "hdfs dfs -put grok /apps/metron/patterns/$SENSOR"
echo \n\n
{% endif %}

echo "########      Create Kafka topic       #########"
sudo su kafka -c "/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --zookeeper {{ cookiecutter.zookeeper_quorum }} --if-not-exists --create --topic {{ cookiecutter.kafka_topic_name }} --partitions {{ cookiecutter.kafka_number_partitions }} --replication-factor {{ cookiecutter.kafka_number_replicas }}"
#curl -iv -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @kafka.json $METRON_REST_URL/api/v1/kafka/topic
echo \n\n