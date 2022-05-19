---
layout: default
title: Azure Log Analytics
parent: Outputs
nav_order: 1
---
# Configure Azure Log Analytics

The Log Export Container uses a [fluentd azure-loganalytics output plugin](https://github.com/yokawasa/fluent-plugin-azure-loganalytics). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=azure-loganalytics` and provide the following variables:
* **AZURE_LOGANALYTICS_CUSTOMER_ID**.  Your Operations Management Suite Workspace ID
* **AZURE_LOGANALYTICS_SHARED_KEY**. The primary or the secondary Connected Sources client authentication key

## Plugin changes

The azure-loganalytics output plugin supports multiple configurations. Please refer to [output-azure-loganalytics.conf](../../fluentd/etc/output-azure-loganalytics.conf)

In case you want to specify different parameters and customize the output plugin, download [output-azure-loganalytics.conf](../../fluentd/etc/output-azure-loganalytics.conf), make your modifications, and pass the file to the container. For example:
```
docker run -p 5140:5140 \
  -v /path-to-your/output-azure-loganalytics.conf:/fluentd/etc/output-azure-loganalytics.conf \
  -e LOG_EXPORT_CONTAINER_INPUT=$LOG_EXPORT_CONTAINER_INPUT \
  -e LOG_EXPORT_CONTAINER_OUTPUT=azure-loganalytics \
  -e AZURE_LOGANALYTICS_CUSTOMER_ID=$AZURE_LOGANALYTICS_CUSTOMER_ID \
  -e AZURE_LOGANALYTICS_SHARED_KEY=$AZURE_LOGANALYTICS_SHARED_KEY log-export-container 
```
