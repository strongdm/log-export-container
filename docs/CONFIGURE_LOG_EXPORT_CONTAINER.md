---
layout: default
title: Configure Log Export Container
nav_order: 2
---

# Configure Log Export Container

## The container

### Required configuration

- **LOG_EXPORT_CONTAINER_INPUT**. Container input format (`syslog-json`, `syslog-csv`, `tcp-json`, `tcp-csv`, `file-json` or `file-csv`). Default: `syslog-json`
- **LOG_EXPORT_CONTAINER_OUTPUT**. Container output storage (`stdout`, `remote-syslog`, `s3`, `cloudwatch`, `splunk-hec`, `datadog`, `azure-loganalytics`, `sumologic`, `kafka`, `mongo`, `logz`, `loki`, `elasticsearch-8` and/or `bigquery`). Default: `stdout`. You could configure multiple storages, for example: `stdout s3 datadog`.

When using `LOG_EXPORT_CONTAINER_INPUT=file-json` or `LOG_EXPORT_CONTAINER_INPUT=file-csv` add variables listed in [CONFIGURE_FILE_INPUT.md](inputs/CONFIGURE_FILE_INPUT.md)

### Optional configuration

#### Remote Syslog

When using `LOG_EXPORT_CONTAINER_OUTPUT=remote-syslog` add variables listed in [CONFIGURE_REMOTE_SYSLOG.md](outputs/CONFIGURE_REMOTE_SYSLOG.md)

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

#### ElasticSearch 8

When using `LOG_EXPORT_CONTAINER_OUTPUT=elasticsearch-8` add variables listed in [CONFIGURE_ELASTICSEARCH.md](outputs/CONFIGURE_ELASTICSEARCH_8.md)

#### BigQuery

When using `LOG_EXPORT_CONTAINER_OUTPUT=bigquery` add variables listed in [CONFIGURE_BIGQUERY.md](outputs/CONFIGURE_BIGQUERY.md)

### Decode Chunk Events

When using `syslog-json` or `tcp-json` specify `LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS=true` to decode chunk events. Possible values: true or false. **It's not enabled by default**. Please refer to [CONFIGURE_SSH_DECODE](processing/CONFIGURE_SSH_DECODE.md) for more information.

### strongDM Audit

When using strongDM Audit specify `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT=activities/15 resources/480 users/480 roles/480`, it'll store the logs from strongDM Audit in your specified output. You can configure this option with whatever features and log extraction interval you want. **It's not enabled by default**. Please refer to [CONFIGURE_SDM_AUDIT](inputs/CONFIGURE_SDM_AUDIT.md) for more information.

We moved the section describing the variable `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES` to [CONFIGURE_SDM_AUDIT](inputs/CONFIGURE_SDM_AUDIT.md) file. Please refer to it to know the behavior with this two variables.

### Source Data

Log traces include: `sourceAddress` and `sourceHostname`. By default docker uses `--net=bridge` networking. You need to enable `--net=host` networking driver in order to see the real client/gateway IP and hostname, otherwise you will see the Docker Gateway's info, for example: `"sourceAddress":"172.17.0.1"`

IMPORTANT: The host networking driver only works in Linux

### Process log traces

By default, the container just classifies the different log traces (e.g. start, chunk, postStart). There are no extra processing steps involved. However, you can include additional processing filters if needed. In order to do that, just override the `process.conf` file. For more details, please refer to [CONFIGURE_PROCESSING.md](processing/CONFIGURE_PROCESSING.md).

## SDM

The current version of the container only supports rsyslog, please refer to the image below to observe a typical configuration:

<img src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" data-canonical-src="https://user-images.githubusercontent.com/313803/123248041-76aab480-d4b5-11eb-8070-9da9619f02f7.png" width="50%" height="50%" />

## High Availability

It's possible to set up a high availability environment using an AWS Load Balancer with more than one LEC instance. Please refer to this tutorial.

https://user-images.githubusercontent.com/82273420/167867989-2eb64a2e-ce18-4b6b-998e-88e5a34a70e7.mp4
