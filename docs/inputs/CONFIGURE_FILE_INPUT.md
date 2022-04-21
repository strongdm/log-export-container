---
layout: default
title: File Input
parent: Inputs
nav_order: 9
---
# Configure File

The Log Export Container uses [fluent plugin tail](https://docs.fluentd.org/input/tail).
In order to enable it you need to specify `LOG_EXPORT_CONTAINER_INPUT=file-json` or `LOG_EXPORT_CONTAINER_INPUT=file-csv` and provide the following variables:

- **LOG_FILE_PATH**. Log file path, e.g. `/var/log/sdm/logs.log`


## Configuration using docker

When using docker you could mount the log file in the container, for example:
```
docker run -v ~/.sdm/logs/:/var/log/sdm/ -e LOG_EXPORT_CONTAINER_INPUT=file-csv -e LOG_EXPORT_CONTAINER_OUTPUT=stdout -e LOG_FILE_PATH=“/var/log/sdm/log-csv.log” public.ecr.aws/strongdm/log-export-container:latest
```

IMPORTANT: 
* Ensure that the log filename matches the value passed via `LOG_FILE_PATH`
* LEC needs the file to be updated in order to start reading it
