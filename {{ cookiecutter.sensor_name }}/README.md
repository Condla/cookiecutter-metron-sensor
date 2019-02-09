# {{ cookiecutter.sensor_name }}

* Enter sensor description _here_:

## Pipeline

* Describe stages that an event passes _here_:

```none
 --> Server logs
     |__NiFi
        |__Kafka
            |__Metron Parsing
               |__Kafka
                  |__Metron Enriching
                     |__Kafka
                        |  |
                       /    \
                    HDFS     Elastic Search


or:

--> Streaming enrichment source
   |__NiFi
      |__Kafka
         |__Metron Parsing
            |__HBase
```

## Filters

* Describe filters and important transformations here on a high level _here_

## Enrichments

* Describe important enrichments qualitatively on a high level _here_

## Facts

* Event Rate:  XXX eps

## Deployment Instructions

* You created this page by running the Metron Sensor Cookiecutter

* Then, check all files that have been created and change anything to fit your needs:

    * Add fields to the Elastic Search template in `elastic.json`

    * If you use Grok, develop your Grok statement and put it into the Grok file

    * add specific enrichments, if required to the `enrichment.json`

* Make sure that the user executing the pipelines, which is usually the `metron` user, has sufficient permissions to read/write to the Kafka topic `{{ cookiecutter.kafka_topic_name }}` and has full permissions to manage the Storm topology `{{ cookiecutter.sensor_name }}`. Apache Ranger is a great tool to do this.

* Then, set the following environment variables

```bash
export SENSOR="{{ cookiecutter.sensor_name }}"
export ELASTIC_USER="{{ cookiecutter.elastic_user }}"
export ELASTIC_PASSWORD="<password>"
export ELASTICMASTER="{{ cookiecutter.elastic_master }}"
export METRON_REST_USER="{{ cookiecutter.metron_user }}"
export METRON_REST_PASSWORD="<password>"
export METRON_REST_URL="{{ cookiecutter.metron_rest }}"
```

* Deploy by executing the `deploy.sh` script that was generated.
* This will upload and deploy all relevant configuration files where Metron expects them to be.
* Note: You need sudo permission to switch to the metron and kafka user to successfully execute this script.

```bash
bash deploy.sh
```


* Check in the Metron Management UI if everything was posted correctly.

* Start the sensor from the Metron Management UI by clicking the "play" button next to the `{{ cookiecutter.sensor_name }}`` sensor.

* Push sample events into Kafka and test the pipeline:

```bash
/usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --broker-list broker1.kafka:6667 --security-protocol SASL_PLAINTEXT --topic {{ cookiecutter.kafka_topic_name }}
```

* Your sensor is now online! :)