# Log Export Container
A docker container that can be easily deployed and configured to export strongDM query logs.

The container acts as a syslog concentrator. Customers that want to export their strongDM query logs to a third party logging service can use the container to do so. They configure the container for the appropriate target. Deploy the container. Configure their strongDM gateways to logs to a syslog destination and set the destination to the address of the logging container.

The container uses [fluentd](https://www.fluentd.org/) for processing and routing your logs. Currently supports routing to: stdout, [S3](https://aws.amazon.com/s3/), [CloudWatch](https://aws.amazon.com/cloudwatch/), [Splunk HEC](https://dev.splunk.com/enterprise/docs/devtools/httpeventcollector/) and [Datadog](https://www.datadoghq.com/). You could configure multiple storages in one container, for example: `stdout s3`.

## Table of Contents
* [Getting Started](#getting-started)
* [Dev Setup](#dev-tools)
* [Contributing](#contributing)
* [Support](#support)

## Getting Started
The Log Export Container is a Docker Image you can use for spinning up multiple containers. You could use the container via plain `docker run` command, docker-compose, k8s, among others. While we integrate with [quay.io](https://quay.io), you could find the generated docker images under [releases](https://github.com/strongdm/log-export-container/releases)

![image](docs/img/simple_demo.gif)

For configuration details, please refer to [CONFIGURE_LOG_EXPORT_CONTAINER.md](docs/CONFIGURE_LOG_EXPORT_CONTAINER.md).

## Dev Tools
If you want to modify the container and quickly see the changes in your local, you could start the container locally and forward the local port to your gateway using:
```
./dev-tools/start-container.sh
```

Considerations:
* Point strongDM syslog to: `mygateway:5140`
* Add `mygateway 127.0.0.1` to your gateway `/etc/hosts`
* For exiting the container: `^C` + `ENTER`

## Contributing
Refer to the [contributing](CONTRIBUTING.md) guidelines or dump part of the information here.

## Support
Refer to the [support](SUPPORT.md) guidelines or dump part of the information here.

