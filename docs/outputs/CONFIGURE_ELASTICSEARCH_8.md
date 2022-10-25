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
* **ELASTICSEARCH_HOST**. ElasticSearch server host, e.g. `127.0.0.1`
* **ELASTICSEARCH_PORT**. ElasticSearch server port, e.g. `9201`. Default: `9200`
* **ELASTICSEARCH_HOSTS**. List of ElasticSearch hosts separated by comma, e.g. `https://user:password@xxxxxxx.us-central1.gcp.cloud.es.io:443/path,http://localhost:9200`.
If you use this variable the previous ones will be ignored.
* **ELASTICSEARCH_INDEX_NAME**. ElasticSearch index name, e.g. `my-index`

**NOTE**: If you need to connect to a secure ElasticSearch deployment you need to use the `ELASTICSEARCH_HOSTS` variable and enter the credentials as shown in its example.
