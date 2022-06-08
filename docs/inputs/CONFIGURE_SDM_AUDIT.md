---
layout: default
title: Audit Activities
parent: Inputs
nav_order: 9
---
# Configure Audit

The Log Export Container uses [fluentd input exec plugin](https://docs.fluentd.org/input/exec) to extract the logs from strongDM Audit.
To export the logs about activities, resources, users and roles coming from strongDM Audit commands, you need to specify the value of the following variable (you should follow the pattern shown below where we have `the name of an entity / the logs extract interval` space-separated):

```
LOG_EXPORT_CONTAINER_EXTRACT_AUDIT=activities/15 resources/480 users/480 roles/480
```

It is worth noting that if you do not specify the interval value after each `/`, the default interval values for each entity will be as defined above.

You will need too provide the following variable:

* **SDM_ADMIN_TOKEN**. Admin Token created in SDM Web UI. You need to check the options `Activities`, `Datasources`, `Users`, `Roles` and `Gateways` to have permissions to extract all logs from the strongDM audit command.

If you want to specifically extract the activity logs you can also use the variables below:

* `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES=true` Variable responsible for indicating whether activity logs will be extracted, default = false.
* `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL=15` Interval in minutes for running the extractor script, default = 15.

However, be aware that if these variables are informed together with `LOG_EXPORT_CONTAINER_EXTRACT_AUDIT`, their content will have priority over the latter.
