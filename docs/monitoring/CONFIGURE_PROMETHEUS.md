# CONFIGURE PROMETHEUS

When Prometheus is enabled, an endpoint is available in port `24321` allowing to see the following metrics:

- `fluentd_input_status_num_records_total` - the total count of received logs by tag (e.g.: `start`, `chunk`, `event`, `postStart`, `complete` and `activity`)
- `fluentd_output_status_emit_count` - the total count of forwarded logs by output (e.g.: `stdout`, `remote-syslog`, `s3`, `cloudwatch`, `splunk-hec`, `datadog`, `azure-loganalytics`, `sumologic`, `kafka`, `mongo`, `loki`, `elasticsearch-8` and `bigquery`)
- `fluentd_output_status_num_errors` - the count of total errors by output match

To enable it, you need to set the variable `LOG_EXPORT_CONTAINER_ENABLE_MONITORING=true`.

To see an example, you can use `docker-compose-prometheus.yml` to run Log Export Container with Prometheus and Grafana. Then you can access the `Log Export Container Metrics` dashboard in Grafana (in the port `3000`) and see how it's used. There we have the following panels:

1. `Received Logs` - count of the received logs per tag in the last 5 minutes

![Received Logs](https://user-images.githubusercontent.com/49597325/167483022-a9138ab5-fded-43c4-8fd1-4b8bba658fad.png)

2. `Forwarded Logs` - count of the forwarded logs to the defined output plugins in the last 5 minutes

![Forwarded Logs](https://user-images.githubusercontent.com/49597325/167483062-f7ca0b9e-49fe-4510-8771-1975b6b528e0.png)

3. `Total Errors Count` - total count of errors in the last 5 minutes

![Total Errors Count](https://user-images.githubusercontent.com/49597325/167483095-2f761777-4d23-4ccc-8bb3-291e90af2336.png)

4. `Last Execution Status By Output` - Last Execution Status by output. It'll show `1` if the last forward try failed, otherwise it'll show `0`.

![Last Execution Status By Output](https://user-images.githubusercontent.com/49597325/167483112-7e5111c4-987c-48e8-b161-9c59296b87c5.png)

Here is a demo video showing the Grafana dashboard:

https://user-images.githubusercontent.com/20745533/173415574-c24b6065-ff4c-4cf9-b456-a80c61c5e449.mp4
