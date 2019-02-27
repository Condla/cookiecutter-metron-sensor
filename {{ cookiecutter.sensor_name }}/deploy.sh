#!bin/env bash

export SENSOR="{{ cookiecutter.sensor_name }}"
export SENSOR="{{ cookiecutter.sensor_name }}"
export ELASTIC_USER="{{ cookiecutter.elastic_user }}"
export ELASTICMASTER="{{ cookiecutter.elastic_master }}"
export METRON_REST_USER="{{ cookiecutter.metron_user }}"
export METRON_REST_URL="{{ cookiecutter.metron_rest }}"


{% if cookiecuuter.sensor_type == "elastic" %}
echo "Deploying ES template..."
{% if cookiecutter.elastic_user == "" %}
curl -X POST $ELASTICMASTER/_template/${SENSOR}_index -d @elastic.json || exit $?
{% else %}
curl -u $ELASTIC_USER:$ELASTIC_PASSWORD -X POST $ELASTICMASTER/_template/${SENSOR}_index -d @elastic.json || exit $?
{% endif %}
echo "    ES tepmlate deployed!"
echo
{% endif %}

{% if cookiecutter.sensor_type == "solr" %}
echo "Deploying Solr schema..."
echo "    Implement Solr schema deployment here!"
echo "    Solr schema deployed!"
echo
{% endif %}

echo "Deploying parser config..."
curl -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @parser.json $METRON_REST_URL/api/v1/sensor/parser/config/$SENSOR || exit $?
echo "    Parser config deployed!"
echo

echo "Deploying enrichment config..."
curl -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @enrichment.json $METRON_REST_URL/api/v1/sensor/enrichment/config/$SENSOR || exit $?
echo "    Enrichment config deployed!"
echo 

echo "Deploying indexing config..."
curl -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @indexing.json $METRON_REST_URL/api/v1/sensor/indexing/config/$SENSOR || exit $?
echo "    Indexing config deployed!"
echo

{% if cookiecutter.parser_type=="Grok" %}
echo "Deploying Grok statement..."
kinit -kt /etc/security/keytabs/metron.headless.keytab metron || exit $?
hdfs dfs -put grok /apps/metron/patterns/$SENSOR || exit $?
echo "    Grok deployed!"
echo
{% endif %}

echo "Creating Kafka topic...""
sudo su kafka -c "/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --zookeeper {{ cookiecutter.zookeeper_quorum }} --if-not-exists --create --topic {{ cookiecutter.kafka_topic_name }} --partitions {{ cookiecutter.kafka_number_partitions }} --replication-factor {{ cookiecutter.kafka_number_replicas }}" || exit $?
#curl -iv -u $METRON_REST_USER:$METRON_REST_PASSWORD -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @kafka.json $METRON_REST_URL/api/v1/kafka/topic
echo "    Kafka topic created!"
echo 