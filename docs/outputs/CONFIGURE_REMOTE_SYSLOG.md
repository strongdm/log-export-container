# Configure Remote Syslog
---
layout: default
title: Remote Syslog
parent: Outputs
nav_order: 9
---
The Log Export Container uses [fluent remote_syslog plugin](https://github.com/fluent-plugins-nursery/fluent-plugin-remote_syslog). In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=remote-syslog` and provide the following variables:
* **REMOTE_SYSLOG_HOST**. Remote Syslog host address.
* **REMOTE_SYSLOG_PORT**. Remote Syslog port.
* **REMOTE_SYSLOG_PROTOCOL**. Remote Syslog protocol. Possible values: `tcp` or `udp`. Default: `tcp`.
