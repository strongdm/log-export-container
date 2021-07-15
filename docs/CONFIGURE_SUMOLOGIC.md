# Configure Sumo Logic

The Log Export Container uses a [fluentd sumologic output plugin](https://github.com/SumoLogic/fluentd-output-sumologic). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=sumologic` and provide the following variables:
* **SUMOLOGIC_ENDPOINT**. SumoLogic HTTP Collector URL
* **SUMOLOGIC_SOURCE_CATEGORY**. Source Category metadata field within SumoLogic, for example: `/prod/sdm/logs`

## Plugin changes

The sumologic output plugin supports multiple configurations. Please refer to [output-sumologic.conf](../fluentd/etc/output-sumologic.conf)

In case you want to specify different parameters and customize the output plugin, download [output-sumologic.conf](../fluentd/etc/output-sumologic.conf), make your modifications, and pass the file to the container. For example:
```
docker run -p 5140:5140 \
  -v /path-to-your/output-sumologic.conf:/fluentd/etc/output-sumologic.conf \
  -e LOG_EXPORT_CONTAINER_INPUT=$LOG_EXPORT_CONTAINER_INPUT \
  -e LOG_EXPORT_CONTAINER_OUTPUT=sumologic \
  -e SUMOLOGIC_ENDPOINT=$SUMOLOGIC_ENDPOINT \
  -e SUMOLOGIC_SOURCE_CATEGORY=$SUMOLOGIC_SOURCE_CATEGORY log-export-container 
```
