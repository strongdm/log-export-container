---
layout: default
title: Big Query
parent: Outputs
nav_order: 12
---
# Configure GCP BigQuery

The Log Export Container uses a [fluent-plugin-bigquery](https://github.com/fluent-plugins-nursery/fluent-plugin-bigquery). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=bigquery` and provide the following variables:
* **BIGQUERY_PRIVATE_KEY**.  Value of the key “private_key” from the JSON downloaded in the KEYS tab present in the “Service Account” menu in the Google Cloud Platform Console
* **BIGQUERY_CLIENT_EMAIL**.  Email address generated when a new service account is created
* **BIGQUERY_PROJECT_ID**.  Project ID created on Google Cloud Platform in the BigQuery menu
* **BIGQUERY_DATASET_ID**.  ID of the dataset created within the project informed in the `BIG_QUERY_PROJECT_ID` variable
* **BIGQUERY_TABLE_ID**.  ID of the table created within the dataset informed in the variable `BIG_QUERY_DATASET_ID`

With all the previous steps done, the LEC will already be sending data to your table in BigQuery, but pay attention that the column names of your table in BigQuery must be the same as the fields returned in the logs. If you have any doubts
about which columns you will need to create, just refer to the example files, for logs received with input in JSON format refer to this [file](../examples/bigquery_table_schema_json_input_example.json) and for logs in CSV format refer to this
[file](../examples/bigquery_table_schema_csv_input_example.json), which can even be used to generate a table with all the fields that the LEC uses

## Plugin changes

The GCP BigQuery output plugin supports multiple configurations. Please refer to [output-bigquery.conf](../../fluentd/etc/output-bigquery.conf)

In case you want to specify different parameters and customize the output plugin, download [output-bigquery.conf](../../fluentd/etc/output-bigquery.conf), make your modifications, and pass the file to the container. For example:
```
docker run -p 5140:5140 \
  -v /path-to-your/output-bigquery.conf:/fluentd/etc/output-bigquery.conf \
  -e LOG_EXPORT_CONTAINER_INPUT=$LOG_EXPORT_CONTAINER_INPUT \
  -e LOG_EXPORT_CONTAINER_OUTPUT=bigquery \
  -e BIGQUERY_PRIVATE_KEY=$BIGQUERY_PRIVATE_KEY \
  -e BIGQUERY_CLIENT_EMAIL=$BIGQUERY_CLIENT_EMAIL \  
  -e BIGQUERY_PROJECT_ID=$BIGQUERY_PROJECT_ID \  
  -e BIGQUERY_DATASET_ID=$BIGQUERY_DATASET_ID \  
  -e BIGQUERY_TABLE_ID=$BIGQUERY_TABLE_ID \ log-export-container 
```
