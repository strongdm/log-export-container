# Log Export Container
A docker container that can be easily deployed and configured to export strongDM query logs.

The container acts as a syslog concentrator. Customers that want to export their strongDM query logs to a third party logging service can use the container to do so. They configure the container for the appropriate target. Deploy the container. Configure their strongDM gateways to logs to a syslog destination and set the destination to the address of the logging container.

The container uses [fluentd](https://www.fluentd.org/) for processing and routing your logs. Currently supports routing to: stdout, [S3](https://aws.amazon.com/s3/), [CloudWatch](https://aws.amazon.com/cloudwatch/), [Splunk HEC](https://dev.splunk.com/enterprise/docs/devtools/httpeventcollector/), [Datadog](https://www.datadoghq.com/), [Azure Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-tutorial) and [Sumo Logic](https://www.sumologic.com/). You could configure multiple storages in one container, for example: `stdout s3`.

## Table of Contents
* [Getting Started](#getting-started)
* [Dev Setup](#dev-tools)
* [Contributing](#contributing)
* [Support](#support)

## Getting Started
The Log Export Container is a Docker Image you can use for spinning up multiple containers. We are in the process of getting this image hosted on [quay.io](https://quay.io), in the meantime you can find the generated docker images under [Releases](https://github.com/strongdm/log-export-container/releases).

1. Go to the [Releases](https://github.com/strongdm/log-export-container/releases) section and expand the "Assets" section for the latest release.
![image](https://user-images.githubusercontent.com/7840034/127922971-2a91175f-6ae3-4043-8c02-da6ffb7ce1d1.png)

2. Copy the URL for .gz file and use `wget` to download it onto the machine you will run the container on.
3. After downloading, open the .gz file and load with Docker
   - For Mac: `gzcat log-export-container-1.0.2.docker-image.tar.gz | docker load`
   - For Linux: `zcat log-export-container-1.0.2.docker-image.tar.gz | sudo docker load`
4. Download the `docker-compose.yml` file from the Github repo onto your machine (or copy-paste it's contents into a file you created directly on the machine with the same name).
   - Make sure the `image` line of the .yml file is pointing to the name of the Docker image you downloaded ![image](https://user-images.githubusercontent.com/7840034/127932766-8bf59074-9f4f-4eac-a85f-a9fca1b9c75a.png)
   - Also make sure that the 'Required variables' in the .yml file are set appropriately based on your desired log format and output destination.
5. Run `sudo docker-compose up`
6. Log into the strongDM Admin UI and go to the Settings page, then the Log Encryption & Storage tab.
7. Set "Log locally on relays?" to 'Yes'
8. Set "Local storage?" to "Syslog" and enter the IP address of the machine running the Log Export Container along with port 5140 ![image](https://user-images.githubusercontent.com/7840034/127934335-239b5e97-772c-4ac6-8e66-864ffaf4cccc.png)
   - Make sure that port 5140 on the machine hosting the container is accesible from your gateways. You can also host the container on your gateways themselves.
9. Set "Local format?" to match the input format you specified in the .yml file.
10. Click "Update" and you're done!
11. If you notice that your strongDM client is stuck in reconnecting mode after hitting update, then it's possible that something went wrong during the setup process. Check your docker settings, security settings, port availability, IP address, and that the Docker image is running correctly.

Here's a gif demonstrating the setup process:

![image](docs/img/simple_demo.gif)

For configuration details, please refer to [CONFIGURE_LOG_EXPORT_CONTAINER.md](docs/CONFIGURE_LOG_EXPORT_CONTAINER.md).

## Dev Tools
If you want to modify the container and quickly see the changes in your local, you could start the container locally and forward the local port to your gateway using:
```
./dev-tools/start-container.sh
```

## Contributing
Refer to the [contributing](CONTRIBUTING.md) guidelines or dump part of the information here.

## Support
Refer to the [support](SUPPORT.md) guidelines or dump part of the information here.

