# Log Export Container
A docker container that can be easily deployed and configured to export strongDM query logs.

The container acts as a syslog concentrator. Customers that want to export their strongDM query logs to a third party logging service can use the container to do so. They configure the container for the appropriate target. Deploy the container. Configure their strongDM gateways to logs to a syslog destination and set the destination to the address of the logging container.

The container uses [fluentd](https://www.fluentd.org/) for processing and routing your logs. Currently supports routing to: stdout, remote syslog, [S3](https://aws.amazon.com/s3/), [CloudWatch](https://aws.amazon.com/cloudwatch/), [Splunk HEC](https://dev.splunk.com/enterprise/docs/devtools/httpeventcollector/), [Datadog](https://www.datadoghq.com/), [Azure Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-tutorial), [Sumo Logic](https://www.sumologic.com/), [Kafka](https://kafka.apache.org/), [Mongo](https://www.mongodb.com/), [Logz](https://logz.io/), [ElasticSearch](https://www.elastic.co/) and [BigQuery](https://cloud.google.com/bigquery). You could configure multiple storages in one container, for example: `stdout s3`.

A curated version of the documentation can be found [here](https://strongdm.github.io/log-export-container/)

## Table of Contents
* [Getting Started](#getting-started)
* [Dev Setup](#dev-tools)
* [Contributing](#contributing)
* [Support](#support)

## Getting Started
The Log Export Container is a Docker Image you can use for spinning up multiple containers. 

1. Download the `docker-compose.yml` file from the Github repo onto your machine (or copy-paste its contents into a file you created directly on the machine with the same name).
   - Make sure that the 'Required variables' in the .yml file are set appropriately based on your desired log format and output destination.
2. Run with your preferred container orchestrator (with docker, you can simply run `docker-compose up`)
3. Log into the strongDM Admin UI and go to the Settings page, then the Log Encryption & Storage tab.
4. Set "Log locally on relays?" to 'Yes'
5. Set "Local storage?" to "Syslog" and enter the IP address of the machine running the Log Export Container along with port 5140
   - ![image](https://user-images.githubusercontent.com/7840034/127934335-239b5e97-772c-4ac6-8e66-864ffaf4cccc.png)
   - Make sure that port 5140 on the machine hosting the container is accesible from your gateways. You can also host the container on your gateways themselves.
6. Set "Local format?" to match the input format you specified in the .yml file.
7. Click "Update" and you're done!
8. If you notice that your strongDM client is stuck in reconnecting mode after hitting update, then it's possible that something went wrong during the setup process. Check your docker settings, security settings, port availability, IP address, and that the Docker image is running correctly.

Here's a gif demonstrating the setup process:

![image](docs/img/simple_demo.gif)

For configuration details, please refer to [CONFIGURE_LOG_EXPORT_CONTAINER.md](docs/CONFIGURE_LOG_EXPORT_CONTAINER.md).

## Dev Tools
If you want to modify the container and quickly see the changes in your local, you could start the container locally and forward the local port to your gateway using:
```
./dev-tools/start-container.sh
```

You could also run the project in your local without docker, please refer to [CONFIGURE_LOCAL_ENV](docs/deploy_log_export_container/CONFIGURE_LOCAL_ENV.md)

## Monitoring
Currently the application supports Prometheus Metrics about the received and forwarded logs. For more details, please see [CONFIGURE_PROMETHEUS](docs/monitoring/CONFIGURE_PROMETHEUS.md)

## Contributing
Refer to the [contributing](CONTRIBUTING.md) guidelines or dump part of the information here.

## Support
Refer to the [support](SUPPORT.md) guidelines or dump part of the information here.
