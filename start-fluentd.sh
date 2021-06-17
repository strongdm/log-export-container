#!/bin/bash

docker build -t log-export-container .
container_id=$(docker ps | grep log-export-container | cut -d' ' -f1)
docker kill $container_id
docker run -p 5140:5140 -v $(pwd)/fluentd/etc:/fluentd/etc log-export-container
