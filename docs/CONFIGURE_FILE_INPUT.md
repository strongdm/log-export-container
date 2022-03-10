# Configure File

The Log Export Container uses [fluent plugin tail](https://docs.fluentd.org/input/tail).
In order to enable it you need to specify `LOG_EXPORT_CONTAINER_INPUT=file-json` or `LOG_EXPORT_CONTAINER_INPUT=file-csv` and provide the following variables:

- **LOG_FILE_PATH**. Log file path, e.g. `/var/log/sdm/logs.log`
