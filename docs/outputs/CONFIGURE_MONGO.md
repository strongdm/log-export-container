---
layout: default
title: Mongo
parent: Outputs
nav_order: 9
---
# Configure Mongo

The Log Export Container uses [fluentd mongo output plugin](https://docs.fluentd.org/output/mongo). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=mongo` and provide the following variables:
* **MONGO_URI**. Mongo Connection URI
* **MONGO_COLLECTION**. Mongo Collection to store the Log Export Container events. Default=sdm_logs.
