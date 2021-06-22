#!/bin/bash

container_id=$(docker ps | grep log-export-container | cut -d' ' -f1)
docker logs -f $container_id
