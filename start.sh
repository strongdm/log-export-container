#!/bin/bash

if [ "$SDM_ADMIN_TOKEN" != "" ]; then
  echo "Starting SDM"
  sdm --admin-token $SDM_ADMIN_TOKEN login
  sdm listen &
  until sdm status &> /dev/null; do
    sleep 1
  done;
fi

echo "Creating Fluentd conf file"
ruby /create-conf.rb

echo "Starting Fluentd"
exec fluentd -c $FLUENTD_DIR/etc/fluent.conf -p $FLUENTD_DIR/plugins
