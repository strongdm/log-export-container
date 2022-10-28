---
layout: default
title: Elasticsearch
parent: Outputs
nav_order: 5
---
# Configure ElasticSearch 8

The Log Export Container uses [fluentd elasticsearch output plugin](https://docs.fluentd.org/output/elasticsearch/) 
and currently it only supports ElasticSearch 8.
In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=elasticsearch-8` and provide the following variables:
* **ELASTICSEARCH_HOSTS**. List of ElasticSearch hosts separated by comma, e.g. `https://username:password@custom-host.com:port/path,http://localhost:9200`.
* **ELASTICSEARCH_INDEX_NAME**. ElasticSearch index name, e.g. `my-index`

**NOTE**: In case you need to connect to a secure ElasticSearch deployment (if you're using [Elastic Cloud](https://www.elastic.co/cloud/) or something similar) you need to add the credentials to the `ELASTICSEARCH_HOSTS` variable. E.g., `ELASTICSEARCH_HOSTS=https://username:password@xxxxxxx.us-central1.gcp.cloud.es.io:443`
