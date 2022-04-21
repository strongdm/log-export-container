---
layout: default
title: Add new output
parent: Outputs
nav_order: 9
---
# Support new Output

In order to support new output types you need to:
1. Add the required plugin gem to the [Gemfile](../Gemfile)
2. Add the new supported type to the [start.sh](../start.sh) script
3. Write a new output file following the plugin's documentation, e.g. [output-s3.conf](../fluentd/etc/output-s3.conf). Ideally just keep the plugin required variables.
4. Update [start-container.sh](../dev-tools/start-container.sh)
5. Update docs:
    * Create a new document, e.g. [CONFIGURE_S3](OUTPUTS/CONFIGURE_S3.md)
    * Add the new output type to [CONFIGURE_LOG_EXPORT_CONTAINER.md](CONFIGURE_LOG_EXPORT_CONTAINER.md)
    * Update [docker-compose.yml](../docker-compose.yml)

IMPORTANT: Please test your changes through the process