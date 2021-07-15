# Configure Log Export Container

## The container

### Required configuration
* **LOG_EXPORT_CONTAINER_INPUT**. Container input format (`json` or `csv`). Default: `json`
* **LOG_EXPORT_CONTAINER_OUTPUT**. Container output storage (`stdout`, `s3`, `cloudwatch`, `splunk-hec`, `datadog`, `azure-loganalytics` and/or `sumologic`). Default: `stdout`. You could configure multiple storages, for example: `stdout s3 datadog`.

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

## SDM
The current version of the container only supports rsyslog, please refer to the image below to observe a typical configuration:

<img src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" data-canonical-src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" width="50%" height="50%" />
