---
layout: default
title: Audit Activities
parent: Additional Configuration
nav_order: 9
---
# Configure Audit Activities

The Log Export Container uses [fluentd input exec plugin](https://docs.fluentd.org/input/exec) to extract the activity logs from SDM CLI Audit.
In order to enable it you need to specify `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES=true` and provide the following variable:
* **SDM_ADMIN_TOKEN**. Admin Token created in SDM Web UI. You need to check the option `Audit -> Activities` to have permissions to extract the activities from the SDM CLI audit command.

If you want to specify the interval frequency for running the extractor script, you can use the following variable:
* **LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL**. Interval in minutes for running the extractor script, default = `15`.
