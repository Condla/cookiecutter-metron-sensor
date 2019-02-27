# Cookiecutter: Metron Sensor

This is a cookiecutter to quickly create all required configs for Apache Metron sensors.

It creates:

* An elastic search basic template.
* The Metron sensor configs:
  * parser.json
  * enrichment.json
  * indexing.json
* One script to deploy them all.

## Features

* Helps you create all required files without thinking about what is needed for the deployment.

## Prerequisites

* Download cookiecutter for your operating system:

```bash
pip install coockiecutter
```

## Usage

* Get the cookiecutter for metron sensors:

```bash
git clone git@github.com:Condla/cookiecutter-metron-sensor.git
```

* Run the cookiecutter:

```bash
cookiecutter cookiecutter-metron-sensor
```

* Follow the instructions on screen by filling out the command line prompts or use the suggested defaults by just pressing return.
* Your sensor files are then created in a directory with the name of the sensor you assigned.
* If you chose a parser type that requires additional configuration, e.g., the Grok parser requires you to create a Grok statement, you need to develop and add that Grok statement now or after the deployment in the Metron Mgmt UI.
* If the parser is stable, i.e., you know the field names, you want to be be indexing, complete the Elastic search template by adding the desired fields and their data types (and removing the ones you don't need if applicable).
* Next, make sure that the user executing the pipelines, which is usually the `metron` user, has sufficient permissions to read/write to the Kafka topic `{{ cookiecutter.kafka_topic_name }}` and has full permissions to manage the Storm topology `{{ cookiecutter.sensor_name }}`. Apache Ranger is a great tool to manage those permissions/policies.
* Then, set the following additional environment variables

```bash
export ELASTIC_PASSWORD="<password>"
export METRON_REST_PASSWORD="<password>"
```

* Deploy by executing the `deploy.sh` script that was generated on a Metron node in the cluster.

* Note: you need to be `root` or `metron` user with the permission to switch to the `kafka` user to execute this script.

```bash
./deploy.sh
```

* Open the Metron Management UI and check if everything was configured correctly.
* Add custom transformations and enrichments.

* Start the sensor from the Metron Management UI by clicking the "play" button next to the sensor name.

* Your sensor is now online!

* Read [this blog entry for more information](https://datahovel.com/2019/02/08/a-cookiecutter-for-metron-sensors/)


## Detailed Description of Options

Most of the variables you have to choose are described in the Metron documentation. The cookiecutter variables have a slightly different name as the Metron ones. This is list is a quick how-to guide and a pointer to more detailed documentation where required.


    "sensor_name": The name as it will be shown in the Management UI. Also the name of the corresponding parser Storm topology.
    "index_name": The name of the index the sensor will be indexing to HDFS/Elastic/Solr.
    "kafka_input_topic_name": The Kafka topic the parser topology will read from.
    "parser_type": Choose one parser type from the list.
    "grok_pattern_label": Only relevant if you chose Grok as your parser type
    "kafka_number_partitions": 2,
    "kafka_number_replicas": 2,
    "storm_number_workers": 2,
    "storm_parser_parallelism": "{{ cookiecutter.kafka_number_partitions }}",
    "sensor_type": ["elastic", "solr", "enrichment", "routing"],
    "batch_indexing_size": 200,
    "ra_indexing_size": 50,
    "shew_table": "enrichment",
    "shew_cf": "t",
    "shew_key_columns": "MyEnrichmentKey",
    "shew_enrichment_type": "myenrichmentname",
    "kafka_output_topic_name": "sensorout"
    "elastic_user": "",
    "elastic_master": "http://elastic.fqdn.com:9200",
    "metron_user": "metron",
    "metron_rest": "http://metron.fqdn.com:8082",
    "zookeeper_quorum": "node1.zookeeper.hostname:2181,node2.zookeper.hostname:2181,node3.zookeper.hostname:2181"