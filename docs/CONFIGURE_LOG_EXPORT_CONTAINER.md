---
layout: default
title: Configure Log Export Container
nav_order: 2
---
# Configure Log Export Container

## The container

### Required configuration

- **LOG_EXPORT_CONTAINER_INPUT**. Container input format (`syslog-json`, `syslog-csv`, `tcp-json`, `tcp-csv`, `file-json` or `file-csv`). Default: `syslog-json`
- **LOG_EXPORT_CONTAINER_OUTPUT**. Container output storage (`stdout`, `remote-syslog`, `s3`, `cloudwatch`, `splunk-hec`, `datadog`, `azure-loganalytics`, `sumologic`, `kafka`, `mongo`, `logz`, `loki` and/or `elasticsearch`). Default: `stdout`. You could configure multiple storages, for example: `stdout s3 datadog`.

When using `LOG_EXPORT_CONTAINER_INPUT=file-json` or `LOG_EXPORT_CONTAINER_INPUT=file-csv` add variables listed in [CONFIGURE_FILE_INPUT.md](inputs/CONFIGURE_ELASTICSEARCH.md)CONFIGURE_FILE_INPUT.md)

### Optional configuration

#### Remote Syslog

When using `LOG_EXPORT_CONTAINER_OUTPUT=remote-syslog` add variables listed in [CONFIGURE_REMOTE_SYSLOG.md](outputs/CONFIGURE_FILE_INPUT.md)

#### AWS S3

When using `LOG_EXPORT_CONTAINER_OUTPUT=s3` add variables listed in [CONFIGURE_S3.md](outputs/CONFIGURE_S3.md)

#### AWS CloudWatch

When using `LOG_EXPORT_CONTAINER_OUTPUT=cloudwatch` add variables listed in [CONFIGURE_CLOUDWATCH.md](outputs/CONFIGURE_CLOUDWATCH.md)

#### Splunk HEC

When using `LOG_EXPORT_CONTAINER_OUTPUT=splunk-hec` add variables listed in [CONFIGURE_SPLUNK_HEC.md](outputs/CONFIGURE_SPLUNK_HEC.md)

#### Datadog

When using `LOG_EXPORT_CONTAINER_OUTPUT=datadog` add variables listed in [CONFIGURE_DATADOG.md](outputs/CONFIGURE_DATADOG.md)

#### Azure Log Analytics

When using `LOG_EXPORT_CONTAINER_OUTPUT=azure-loganalytics` add variables listed in [CONFIGURE_AZURE_LOGANALYTICS.md](outputs/CONFIGURE_AZURE_LOGANALYTICS.md)

#### Sumo Logic

When using `LOG_EXPORT_CONTAINER_OUTPUT=sumologic` add variables listed in [CONFIGURE_SUMOLOGIC.md](outputs/CONFIGURE_SUMOLOGIC.md)

#### Kafka

When using `LOG_EXPORT_CONTAINER_OUTPUT=kafka` add variables listed in [CONFIGURE_KAFKA.md](outputs/CONFIGURE_KAFKA.md)

#### Mongo

When using `LOG_EXPORT_CONTAINER_OUTPUT=mongo` add variables listed in [CONFIGURE_MONGO.md](outputs/CONFIGURE_MONGO.md)

#### Logz

When using `LOG_EXPORT_CONTAINER_OUTPUT=logz` add variables listed in [CONFIGURE_LOGZ.md](outputs/CONFIGURE_LOGZ.md)

#### Grafana Loki

When using `LOG_EXPORT_CONTAINER_OUTPUT=loki` add variables listed in [CONFIGURE_LOKI.md](outputs/CONFIGURE_LOKI.md)

#### ElasticSearch

When using `LOG_EXPORT_CONTAINER_OUTPUT=elasticsearch` add variables listed in [CONFIGURE_ELASTICSEARCH.md](outputs/CONFIGURE_ELASTICSEARCH.md)

### Decode Chunk Events

When using `syslog-json` or `tcp-json` specify `LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS=true` to decode chunk events. Possible values: true or false. **It's not enabled by default**. Please refer to [CONFIGURE_SSH_DECODE](processing/CONFIGURE_SSH_DECODE.md) for more information.

### Audit Activities

When using `LOG_EXPORT_CONTAINER_OUTPUT=mongo` specify `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES=true` to store the activity logs from SDM CLI Audit in your MongoDB. Possible values: true or false. **It's not enabled by default**. Please refer to [CONFIGURE_AUDIT_ACTIVITIES](inputs/CONFIGURE_AUDIT_ACTIVITIES.md) for more information.

### Source Data

Log traces include: `sourceAddress` and `sourceHostname`. By default docker uses `--net=bridge` networking. You need to enable `--net=host` networking driver in order to see the real client/gateway IP and hostname, otherwise you will see the Docker Gateway's info, for example: `"sourceAddress":"172.17.0.1"`

IMPORTANT: The host networking driver only works in Linux

### Process log traces

By default, the container just classifies the different log traces (e.g. start, chunk, postStart). There are no extra processing steps involved. However, you can include additional processing filters if needed. In order to do that, just override the `process.conf` file. For more details, please refer to [CONFIGURE_PROCESSING.md](processing/CONFIGURE_PROCESSING.md).

## SDM

The current version of the container only supports rsyslog, please refer to the image below to observe a typical configuration:

<img src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" data-canonical-src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" width="50%" height="50%" />
