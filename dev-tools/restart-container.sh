#!/bin/bash

get_container_id() {
  docker ps | grep log-export-container | cut -d' ' -f1
}

if [ "$(get_container_id)" != "" ]; then
  docker kill $(get_container_id)
fi

docker build -t log-export-container .
docker run -p 5140:5140 -d \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e S3_BUCKET=$S3_BUCKET \
  -e S3_REGION=$S3_REGION \
  -e S3_PATH=$S3_PATH log-export-container

ssh -R 5140:localhost:5140 -i $LOG_EXPORT_CONTAINER_SSH_CREDENTIALS $LOG_EXPORT_CONTAINER_SSH_DESTINATION
