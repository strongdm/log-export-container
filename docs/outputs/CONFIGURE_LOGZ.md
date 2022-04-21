---
layout: default
title: Logz
parent: Outputs
nav_order: 6
---
# Configure Logz

The Log Export Container uses [fluent plugin logzio](https://github.com/logzio/fluent-plugin-logzio).
In order to enable it you need to specify `LOG_EXPORT_CONTAINER_OUTPUT=logz` and provide the following variables:
* **LOGZ_ENDPOINT**. Logz.io Endpoint URL, e.g. `https://listener.logz.io:8071?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&type=my_type`
