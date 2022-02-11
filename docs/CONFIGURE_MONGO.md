# Configure Mongo

The Log Export Container uses [fluentd mongo output plugin](https://docs.fluentd.org/output/mongo). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=mongo` and provide the following variables:
* **MONGO_URI**. Mongo Connection URI
* **MONGO_COLLECTION**. Mongo Collection to store the Log Export Container logs. Default=sdm_logs.
