# Log Export Container
A docker container that can be easily deployed and configured to export strongDM query logs.

The container acts as a syslog concentrator. Customers that want to export their strongDM query logs to a third party logging service can use the container to do so. They configure the container for the appropriate target. Deploy the container. Configure their strongDM gateways to logs to a syslog destination and set the destination to the address of the logging container.

## Table of Contents
* [Getting Started](#getting-started)
* [Dev Setup](#dev-setup)
* [Contributing](#contributing)
* [Support](#support)

## Getting Started
The Log Export Container is a Docker Image you can use for spinning up multiple containers. For configuration details, please refer to [CONFIGURE_LOG_EXPORT_CONTAINER.md](docs/CONFIGURE_LOG_EXPORT_CONTAINER.md).

You could use the container via plain `docker run` command, docker-compose, k8s, among others. For simplicity sake, you could clone the repo and quickly start using executing the following file: 
```
./docker-start.sh
```

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

