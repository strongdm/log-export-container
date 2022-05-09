# CONFIGURE PROMETHEUS

Currently, a metrics endpoint is available in port `24321` enabling to see the following metrics:
- `fluentd_input_status_num_records_total` - the total count of received logs by tag (e.g.: `start`, `chunk`, `event`, `postStart`, `complete` and `activity`)
- `fluentd_output_status_emit_count` - the total count of forwarded logs by output (e.g.: `stdout`, `remote-syslog`, `s3`, `cloudwatch`, `splunk-hec`, `datadog`, `azure-loganalytics`, `sumologic`, `kafka`, `mongo`, `loki`, `elasticsearch` and `bigquery`)
- `fluentd_output_status_num_errors` - the count of total errors by output match

To enable it, you need to set the variable `LOG_EXPORT_CONTAINER_ENABLE_MONITORING=true`.

To see an example, follow these steps:
1. Download the file [docker-compose-prometheus.yml](../../docker-compose-prometheus.yml);
  - Make sure that the 'Required variables' in the `log-export-container` service in the .yml file are set appropriately based on your desired log format and output destination.
2. Run with your preferred container orchestrator (with docker, you can simply run `docker-compose up`)
3. Log into the strongDM Admin UI and go to the Settings page, then the Log Encryption & Storage tab.
4. Set "Log locally on relays?" to 'Yes'
5. Set "Local storage?" to "Syslog" and enter the IP address of the machine running the Log Export Container along with port 5140 ![image](https://user-images.githubusercontent.com/7840034/127934335-239b5e97-772c-4ac6-8e66-864ffaf4cccc.png)
   - Make sure that port 5140 on the machine hosting the container is accesible from your gateways. You can also host the container on your gateways themselves.
6. Set "Local format?" to match the input format you specified in the .yml file.
7. Click "Update" and you're done!
8. If you notice that your strongDM client is stuck in reconnecting mode after hitting update, then it's possible that something went wrong during the setup process. Check your docker settings, security settings, port availability, IP address, and that the Docker image is running correctly.

Here's a gif demonstrating the setup process:

![image](../img/simple_demo.gif)

Then you can access the `Log Export Container Metrics` dashboard in Grafana (in the port `3000`) and see how it's used. There we have the following panels:

1. `Received Logs` - count of the received logs per tag in the last 5 minutes
2. `Forwarded Logs` - count of the forwarded logs to the defined output plugins in the last 5 minutes
3. `Total Errors Count` - total count of errors in the last 5 minutes
4. `Last Execution Status By Output` - Last Execution Status by output. It'll show `1` if the last forward try failed, otherwise it'll show `0`.
