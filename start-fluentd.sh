#!/bin/bash

docker build -t log-export-container .
container_id=$(docker ps | grep log-export-container | cut -d' ' -f1)
docker kill $container_id
docker run -p 5140:5140 \
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e S3_BUCKET=$S3_BUCKET \
  -e S3_REGION=$S3_REGION \
  -e S3_PATH=$S3_PATH \
  -v $(pwd)/fluentd/etc:/fluentd/etc log-export-container
