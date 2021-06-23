# Log Export Container
A docker container that can be easily deployed and configured to export strongDM query logs.

The container acts as a syslog concentrator. Customers that want to export their strongDM query logs to a third party logging service can use the container to do so. They configure the container for the appropriate target. Deploy the container. Configure their strongDM gateways to logs to a syslog destination and set the destination to the address of the logging container.

## Table of Contents
* [Getting Started](#getting-started)
* [Dev Setup](#dev-setup)
* [Contributing](#contributing)
* [Support](#support)

## Getting Started
Please refer to the [docker-compose](docker-compose.yml) file for config details. Set variables and start your container.
```
./docker-start.sh
```

## Dev Setup
Start container and SSH tunnel:
```
./dev-tools/start-container.sh
```

Considerations:
* Configure strongDM syslog: `mygateway:5140`
* Add `mygateway 127.0.0.1` to your gateway
* Exit process: ^C + ENTER

## Contributing
Refer to the [contributing](CONTRIBUTING.md) guidelines or dump part of the information here.

## Support
Refer to the [support](SUPPORT.md) guidelines or dump part of the information here.

