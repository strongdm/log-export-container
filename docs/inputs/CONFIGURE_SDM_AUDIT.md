---
layout: default
title: Audit Activities
parent: Inputs
nav_order: 9
---

# Configure strongDM CLI Audit

First, to make this work, you need to provide the following variable:

- **SDM_ADMIN_TOKEN**. Admin Token created in SDM Web UI. You need to check the options `Activities`, `Datasources`, `Users`, `Roles` and `Gateways` to have permissions to extract all logs from the SDM CLI audit command.

## Configure Periodic Audit Data Extraction

The Log Export Container uses [fluentd input exec plugin](https://docs.fluentd.org/input/exec) to extract the logs from strongDM CLI Audit command.
To export the logs about activities, resources, users and roles coming from strongDM CLI Audit command, you need to specify the value of the following variable with the name of the entity (activities, resources, users or roles) and the extract interval in minutes (you should follow the pattern shown below where we have `entity_name/extract_interval` space-separated):

```
LOG_EXPORT_CONTAINER_EXTRACT_AUDIT=activities/15 resources/480 users/480 roles/480
```

It is worth noting that if you don't specify the interval value after each `/`, the default interval values for each entity will be as defined above.

If you want to specifically extract the activity logs you can also use the variables below:

- `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES=true` Variable responsible for indicating whether activity logs will be extracted, default = false.
- `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL=15` Interval in minutes for running the extractor script, default = 15.

However, be aware that if these variables are informed together with `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT`, their content will have priority over `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT`.

## Configure Stream

If you want to see the Audit Data in real-time, it's possible to configure a Stream to file and read that using tail. Then you need to specify the following variables:

- **LOG_EXPORT_CONTAINER_STREAM_AUDIT_ENTITY**. Entity to be streamed (possible values: `activities`)
- **LOG_EXPORT_CONTAINER_INPUT=file-json**. The input type needs to be `file-json` to listen the streamed content file

**NOTE**: Different from [CONFIGURE_FILE_INPUT](../inputs/CONFIGURE_FILE_INPUT.md) set up, you don't need
to specify the `LOG_FILE_PATH` variable, because it's automatically defined when using `LOG_EXPORT_CONTAINER_STREAM_AUDIT_ENTITY`
