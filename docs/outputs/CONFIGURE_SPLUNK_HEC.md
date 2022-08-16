---
layout: default
title: Splunk HEC
parent: Outputs
nav_order: 12
---


# Configure Splunk HEC

The Log Export Container uses [fluentd splunk hec output plugin](https://github.com/splunk/fluent-plugin-splunk-hec). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=splunk-hec` and provide the following variables:
* **SPLUNK_HEC_HOST**. The hostname/IP for the HEC token or the HEC load balancer. E.g., `prd-p-xxxxx.splunkcloud.com`
* **SPLUNK_HEC_PORT**. The port number for the HEC token or the HEC load balancer. E.g., `8088`
* **SPLUNK_HEC_TOKEN**. Identifier for the HEC token. E.g., `xxxxxxxx-yyyy-yyyy-yyyy-zzzzzzzzzzzz`

IMPORTANT: SSL validation is disabled by default, you can pass different [SSL Params](https://github.com/splunk/fluent-plugin-splunk-hec#ssl-parameters) overriding the builtin configuration as commented below

## Plugin changes

The splunk output plugin supports multiple configurations. Please refer to [output-splunk-hec.conf](../../../fluentd/etc/output-splunk-hec.conf)

In case you want to specify different parameters and customize the output plugin, you could download [output-splunk-hec.conf](../../../fluentd/etc/output-splunk-hec.conf), make your modifications, and pass the file to the container. For example:
```
docker run -p 5140:5140 \
  -v /path-to-your/output-splunk.conf:/fluentd/etc/output-splunk.conf \
  -e LOG_EXPORT_CONTAINER_INPUT=$LOG_EXPORT_CONTAINER_INPUT \
  -e LOG_EXPORT_CONTAINER_OUTPUT=splunk \
  -e SPLUNK_HEC_HOST=$SPLUNK_HEC_HOST \
  -e SPLUNK_HEC_PORT=$SPLUNK_HEC_PORT \
  -e SPLUNK_HEC_TOKEN=$SPLUNK_HEC_TOKEN log-export-container 
```

## References

* [Configure HTTP Event Collector on Splunk Cloud](https://docs.splunk.com/Documentation/Splunk/latest/Data/UsetheHTTPEventCollector#Configure_HTTP_Event_Collector_on_Splunk_Cloud)
* [Can't resolve hostname for HTTP Event Collector](https://community.splunk.com/t5/Splunk-Cloud-Platform/Can-t-resolve-hostname-for-HTTP-Event-Collector/m-p/518245)
* [Why would I use the HTTP Event Collector when I can use TCP?](https://community.splunk.com/t5/Getting-Data-In/Why-would-I-use-the-HTTP-Event-Collector-when-I-can-use-TCP/m-p/233205)
