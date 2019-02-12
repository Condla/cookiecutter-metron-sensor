# Cookiecutter: Metron Sensor

A cookiecutter to quickly create all required configs Apache Metron sensors.

It creates:

* elastic search basic template
* a deployment script
* the Metron sensor configs (parser.json, enrichment.json, indexing.json)

...and gives the option to specify a streaming enrichment source or a conventional sensor.

So at the moment it does not (much) more that the Metron Management UI does, but from the convenience of the command line and already organized in a directory structure, ready to be versioned.

## Prerequisites

* Download cookiecutter for your operating system

```
pip install coockiecutter
```

## Usage

* Run cookiecutter

```
git clone git@github.com:Condla/cookiecutter-metron-sensor.git
cookiecutter cookiecutter-metron-sensor
```

* Follow the instructions on screen by filling out the command line prompts or using the suggested defaults.

* Your sensor files are created in a directory with the name of the sensor you assigned.

* This directory contains all the files you need to successfully onboard a new sensor to Apache Metron.

* The directory contains a README.md file with deployment instructions _specific_ to your newly created sensor.

* Read [this blog entry for more information](https://datahovel.com/2019/02/08/a-cookiecutter-for-metron-sensors/)