---
layout: default
title: Log Processing
parent: Additional Configuration
nav_order: 9
---
# Configure Extra Processing

The container includes all plugins provided by the [fluent/fluentd/alpine:edge](https://hub.docker.com/r/fluent/fluentd/) docker image and custom additions. Check out the full list in the [Dockerfile](../Dockerfile).

With the available plugins you could process log traces, adding, changing or removing information. For example: a customer might want to avoid exporting all raw data to their external Logging Service - there could be sensitive data (e.g. credentials) being exposed.

In order to include extra processing steps in your pipeline, just download [process.conf](../fluentd/etc/process.conf), make your modifications, and pass the file to the container. For example:
```
docker run -p 5140:5140 \
  -v /path-to-your/process.conf:/fluentd/etc/process.conf \
  <env-variables> log-export-container 
```

## Sanitizer

You might ask: "Can I remove X from the query log?", or, "we have to see API keys in our SSH sessions and I'd prefer to scrub them". For those type of use cases, we have added the [fluentd sanitizer plugin](https://github.com/fluent/fluent-plugin-sanitizer) to the container.

The Sanitizer plugin allows you to obfuscate all or certain parts a log trace. Please refer to the [documentation](https://github.com/fluent/fluent-plugin-sanitizer) for more details.

The current [process.conf](../fluentd/etc/process.conf) includes some examples you could just, uncoment and start to use now. From the provided sample rules:

Rules:
```
<filter **>
  @type                     sanitizer
  hash_salt                 sdmsalt
  <rule> 
    keys                    query
    pattern_regex           /SET PASSWORD .*/
    pattern_regex_prefix    "CHANGE_PASSWORD"
  </rule>
  <rule> 
    keys                    query
    pattern_regex           /ALTER USER .+ IDENTIFIED BY .+/
    pattern_regex_prefix    "CHANGE_PASSWORD"
  </rule>
</filter>
```

Input:
```
mysql> ALTER USER 'user-name'@'localhost' IDENTIFIED BY '123'
```

Output:
```
2021-07-16 10:41:00.695647700 +0000 class.start: {"sourceAddress":"192.168.0.2","sourceHostname":"my-gw","timestamp":"2021-07-16T10:41:00Z","type":"start","uuid":"01vOTJBv38C4Vp9dLv8C5qvEHY43","datasourceId":"rs-26a4c33360a277rt","datasourceName":"docker-mysql","userId":"a-0326fcc060460b7d","userName":"Rodolfo Me Campos","query":"CHANGE_PASSWORD_bd63d87d755730a573634356576fb5c0","hash":"aa85c84cc24b53336a355c99978e3e935f544bf2"}
```
