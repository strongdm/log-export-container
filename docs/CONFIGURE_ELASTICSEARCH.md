# Configure ElasticSearch

The Log Export Container uses [fluentd elasticsearch output plugin](https://docs.fluentd.org/output/elasticsearch/).
In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=elasticsearch` and provide the following variables:
* **ELASTICSEARCH_HOST**. ElasticSearch server host, e.g. `127.0.0.1`
* **ELASTICSEARCH_PORT**. ElasticSearch server port, e.g. `9201`. Default: `9200`
* **ELASTICSEARCH_INDEX_NAME**. ElasticSearch index name, e.g. `my-index`
