---
layout: default
title: S3
parent: Outputs
nav_order: 11
---
# Configure AWS S3

The Log Export Container uses [fluentd s3 output plugin](https://docs.fluentd.org/output/s3). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=s3` and provide the following variables:
* **AWS_ACCESS_KEY_ID**. AWS Access Key
* **AWS_SECRET_ACCESS_KEY**. AWS Access Secret
* **S3_BUCKET**. AWS S3 Bucket Name, for example: `log-export-container`
* **S3_REGION**. AWS S3 Bucket Region Name, for example: `us-west-2`
* **S3_PATH**. AWS S3 Path to Append to your Logs, for example: `logs`. The actual path on S3 will be: `{path}{container_id}{time_slice_format}_{sequential_index}.gz (see s3_object_key_format)`

## Plugin changes

The s3 output plugin supports multiple configurations. Log Export Container uses an in-memory buffer with almost default params. Please refer to [output-s3.conf](../fluentd/etc/output-s3.conf)

In case you want to specify different parameters and customize the output plugin, you could download [output-s3.conf](../fluentd/etc/output-s3.conf), make your modifications, and pass the file to the container. For example:
```
docker run -p 5140:5140 \
  -v /path-to-your/output-s3.conf:/fluentd/etc/output-s3.conf \
  -e LOG_EXPORT_CONTAINER_INPUT=$LOG_EXPORT_CONTAINER_INPUT \
  -e LOG_EXPORT_CONTAINER_OUTPUT=s3 \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e S3_BUCKET=$S3_BUCKET \
  -e S3_REGION=$S3_REGION \
  -e S3_PATH=$S3_PATH log-export-container 
```
