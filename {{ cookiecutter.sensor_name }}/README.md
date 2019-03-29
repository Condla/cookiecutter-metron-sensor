# {{ cookiecutter.sensor_name }}

* Enter sensor description _here_:

## Pipeline

* Describe stages that an event passes _here_:

{% if cookiecutter.sensor_type in ["elastic", "solr"] %}
```none
 --> Server logs
     |__NiFi
        |__Kafka topic: "{{ cookiecutter.kafka_input_topic_name }}"
            |__Storm topology: "{{ cookiecutter.sensor_name }}"
               |__Kafka topic: "enrichments"
                  |__Metron Enrichment topology
                     |__Kafka topic: "indexing"
                        |  |
                       /    \
                    hdfs     {{ cookiecutter.sensor_type }}: "{{ cookiecutter.index_name}}"
```
{% endif %}

{% if cookiecutter.sensor_type in ["enrichment"] %}
```none
--> Streaming enrichment source
   |__NiFi
      |__Kafka topic: {{ cookiecutter.kafka_input_topic_name }}
         |__Storm topology: "{{ cookiecutter.sensor_name }}"
            |__HBase table: {{ cookiecutter.shew_table }}
```
{% endif %}

{% if cookiecutter.sensor_type in ["routing"] %}
```none
--> Server logs
   |__NiFi
      |__Kafka topic: {{ cookiecutter.kafka_input_topic_name }}
         |__Storm topology: "{{ cookiecutter.sensor_name }}"
            |__Kafka topic: {{ cookiecutter.kafka_output_topic_name }}
```
{% endif %}

## Filters and Parser Transformations

* Describe filters and important transformations here on a high level _here_

## Enrichments and Transformations

* Describe important enrichments qualitatively on a high level _here_

## Facts

* Event Rate:  XXX eps

## Useful commands

{% if cookiecutter.sensor_type == "elastic" %}
### Deploy ES Template
{% if cookiecutter.elastic_user == "" %}
```bash
curl -X POST {{ cookiecutter.elastic_master }}/_template/{{ cookiecutter.sensor_name }}_index -d @elastic.json
```
{% else %}
```bash
curl -u {{ cookiecutter.elastic_user }} -X POST {{ cookiecutter.elastic_master }}/_template/{{ cookiecutter.sensor_name }}_index -d @elastic.json
```
{% endif %}
{% endif %}

{% if cookiecutter.sensor_type == "solr" %}
### Deploy Solr Schema

```bash
solr commmand is here ;)
```
{% endif %}


export METRON_REST_USER="{{ cookiecutter.metron_user }}"
export METRON_REST_URL="{{ cookiecutter.metron_rest }}"

### Post Parser Config

```bash
curl -u {{ cookiecutter.metron_user }} -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @parser.json {{ cookiecutter.metron_rest }}/api/v1/sensor/parser/config/{{ cookiecutter.sensor_name }}
```

### Post Enrichment Config

```bash
curl -u {{ cookiecutter.metron_user }} -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @enrichment.json {{ cookiecutter.metron_rest }}/api/v1/sensor/enrichment/config/{{ cookiecutter.sensor_name }}
```

### Post Indexing Config

```bash
curl -u {{ cookiecutter.metron_user }} -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d @indexing.json {{ cookiecutter.metron_rest }}/api/v1/sensor/indexing/config/{{ cookiecutter.sensor_name }}
```
### Deploy Grok statement

{% if cookiecutter.parser_type=="Grok" %}
kinit -kt /etc/security/keytabs/metron.headless.keytab metron
hdfs dfs -put grok /apps/metron/patterns/{{ cookiecutter.sensor_name }}
{% endif %}

### Create Kafka topics

```bash
sudo su kafka -c "/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --zookeeper {{ cookiecutter.zookeeper_quorum }} --if-not-exists --create --topic {{ cookiecutter.kafka_input_topic_name }} --partitions {{ cookiecutter.kafka_number_partitions }} --replication-factor {{ cookiecutter.kafka_number_replicas }}"
```

### Push Sensor Samples into Kafka

```bash
cat samples | /usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --broker-list broker1.kafka:6667 --security-protocol SASL_PLAINTEXT --topic {{ cookiecutter.kafka_input_topic_name }}
```
