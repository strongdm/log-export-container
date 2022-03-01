# Configure Loki

The Log Export Container uses [fluent plugin grafana loki](https://grafana.com/docs/loki/latest/clients/fluentd/).
In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=loki` and provide the following variables:
* **LOKI_URL**. Loki Endpoint URL, e.g. `http://localhost:3100`

