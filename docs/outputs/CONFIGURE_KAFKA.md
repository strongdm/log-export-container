---
layout: default
title: Kafka
parent: Outputs
nav_order: 2
---
# Configure AWS CloudWatch

The Log Export Container uses a [fluentd kafka output plugin](https://github.com/fluent/fluent-plugin-kafka). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=kafka` and provide the following variables:
* **KAFKA_BROKERS**. List of brokers, following the format: `<broker1_host>:<broker1_port>,<broker2_host>:<broker2_port>`
* **KAFKA_TOPIC**. Topic name 
* **KAFKA_FORMAT_TYPE**. Input text type, for example: `text, json, ltsv, msgpack`. Default = json

## Plugin changes

The kafka output plugin supports multiple configurations. Please refer to [output-kafka.conf](../fluentd/etc/output-kafka.conf)

In case you want to specify different parameters and customize the output plugin, you could download [output-kafka.conf](../fluentd/etc/output-kafka.conf), make your modifications, and pass the file to the container. For example:
```
docker run -p 5140:5140 \
  -v /path-to-your/output-cloudwatch.conf:/fluentd/etc/output-cloudwatch.conf \
  -e LOG_EXPORT_CONTAINER_INPUT=$LOG_EXPORT_CONTAINER_INPUT \
  -e LOG_EXPORT_CONTAINER_OUTPUT=kafka \
  -e KAFKA_BROKERS=$KAFKA_BROKERS \
  -e KAFKA_TOPICS=$KAFKA_TOPICS \
  -e KAFKA_FORMAT_TYPE=$KAFKA_FORMAT_TYPE log-export-container
```
