#!/bin/bash

container_id=$(docker ps | grep log-export-container | cut -d' ' -f1)
docker exec -it $container_id kill -1 1
ssh -R 5140:localhost:5140 -i $LOG_EXPORT_CONTAINER_SSH_CREDENTIALS $LOG_EXPORT_CONTAINER_SSH_DESTINATION
