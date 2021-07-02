#!/bin/bash

docker build -t log-export-container .
docker-compose up -d
