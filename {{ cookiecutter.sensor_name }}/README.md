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

    * add fields to the Elastic Search template in `elastic.json`

    * change Storm settings based on the number of expected event in the `parser.json`

    * add specific enrichments if required to the `enrichment.json`

    * configure the `batchSize` according to your throughput in the `

    * 

* Then, set the following environment variables

```bash
export SENSOR="{{ cookiecutter.sensor_name }}"
export ELASTIC_USER="elastic"
export ELASTIC_PASSWORD="<password>"
export ELASTICMASTER="https://elastic.fqdn.com:9200"
export METRON_REST_USER="metron"
export METRON_REST_PASSWORD="<password>"
export METRON_REST_URL="https://metron.fqdn.com:8082"
```

* Deploy by executing the `deploy.sh` script.

```
bash deploy.sh
```

This will upload all required file 

* Check in the Metron Management UI if everything was posted correctly.

* Make sure that the user executing the pipelines, which is usually the `metron` user, has sufficient permissions to read/write to the Kafka topic `{{ cookiecutter.kafka_topic_name }}` and has full permissions to manage the Storm topology `{{ cookiecutter.sensor_name }}`

* Start the sensor from the Metron Management UI by clicking the "play" button next to the `{{ cookiecutter.sensor_name }}`` sensor.

* Push sample events into Kafka and test the pipeline.

```bash
/usr/hdp/current/kafka-broker/bin/kafka-console-producer.sh --broker-list broker1.kafka:6667 --security-protocol SASL_PLAINTEXT --topic {{ cookiecutter.kafka_topic_name }}
```

* Your sensor is now online! :)