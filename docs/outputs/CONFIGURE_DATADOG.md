---
layout: default
title: Datadog
parent: Outputs
nav_order: 1
---
# Configure Datadog

The Log Export Container uses a [fluentd datadog output plugin](https://github.com/DataDog/fluent-plugin-datadog). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=datadog` and provide the following variables:
* **DATADOG_API_KEY**. This parameter is required in order to authenticate your fluent agent. Generate under: Integrations > APIs

## Plugin changes

The datadog output plugin supports multiple configurations. Please refer to [output-datadog.conf](../fluentd/etc/output-datadog.conf)

In case you want to specify different parameters and customize the output plugin, you could download [output-datadog.conf](../fluentd/etc/output-datadog.conf), make your modifications, and pass the file to the container. For example:
```
docker run -p 5140:5140 \
  -v /path-to-your/output-datadog.conf:/fluentd/etc/output-datadog.conf \
  -e LOG_EXPORT_CONTAINER_INPUT=$LOG_EXPORT_CONTAINER_INPUT \
  -e LOG_EXPORT_CONTAINER_OUTPUT=datadog \
  -e DATADOG_API_KEY=$DATADOG_API_KEY log-export-container 
```
