# Configure Log Export Container

## The container

### Required configuration
* **LOG_EXPORT_CONTAINER_INPUT**. Container input format (`json` or `csv`). Default: `json`
* **LOG_EXPORT_CONTAINER_OUTPUT**. Container output storage (`stdout`, `s3`, `cloudwatch`, `splunk-hec`, `datadog`, `azure-loganalytics`, `sumologic` and/or  `kafka`). Default: `stdout`. You could configure multiple storages, for example: `stdout s3 datadog`.

### Optional configuration
#### AWS S3
When using `LOG_EXPORT_CONTAINER_OUTPUT=s3` add variables listed in [CONFIGURE_S3.md](CONFIGURE_S3.md)

#### AWS CloudWatch
When using `LOG_EXPORT_CONTAINER_OUTPUT=cloudwatch` add variables listed in [CONFIGURE_CLOUDWATCH.md](CONFIGURE_CLOUDWATCH.md)

#### Splunk HEC
When using `LOG_EXPORT_CONTAINER_OUTPUT=splunk-hec` add variables listed in [CONFIGURE_SPLUNK_HEC.md](CONFIGURE_SPLUNK_HEC.md)

#### Datadog
When using `LOG_EXPORT_CONTAINER_OUTPUT=datadog` add variables listed in [CONFIGURE_DATADOG.md](CONFIGURE_DATADOG.md)

#### Azure Log Analytics
When using `LOG_EXPORT_CONTAINER_OUTPUT=azure-loganalytics` add variables listed in [CONFIGURE_AZURE_LOGANALYTICS.md](CONFIGURE_AZURE_LOGANALYTICS.md)

#### Sumo Logic
When using `LOG_EXPORT_CONTAINER_OUTPUT=sumologic` add variables listed in [CONFIGURE_SUMOLOGIC.md](CONFIGURE_SUMOLOGIC.md)

#### Kafka
When using `LOG_EXPORT_CONTAINER_OUTPUT=kafka` add variables listed in [CONFIGURE_KAFKA.md](CONFIGURE_KAFKA.md)

### Source Data

Log traces include: `sourceAddress` and `sourceHostname`. By default docker uses `--net=bridge` networking. You need to enable `--net=host` networking driver in order to see the real client/gateway IP and hostname, otherwise you will see the Docker Gateway's info, for example: `"sourceAddress":"172.17.0.1"`

IMPORTANT: The host networking driver only works in Linux

### Process log traces

By default, the container just classifies the different log traces (e.g. start, chunk, postStart). There are no extra processing steps involved. However, you can include additional processing filters if needed. In order to do that, just override the `process.conf` file. For more details, please refer to [CONFIGURE_PROCESSING.md](CONFIGURE_PROCESSING.md).

## SDM
The current version of the container only supports rsyslog, please refer to the image below to observe a typical configuration:

<img src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" data-canonical-src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" width="50%" height="50%" />
