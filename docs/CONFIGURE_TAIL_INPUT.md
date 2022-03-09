# Configure Tail

The Log Export Container uses [fluent plugin tail](https://docs.fluentd.org/input/tail).
In order to enable it you need to specify `LOG_EXPORT_CONTAINER_INPUT=tail-json` or `LOG_EXPORT_CONTAINER_INPUT=tail-csv` and provide the following variables:
* **TAIL_FILE_PATH**. Log file path, e.g. `/var/logs/sdm/logs.log`

