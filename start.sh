#!/bin/sh

if [ "$SDM_ADMIN_TOKEN" != "" ]; then
  echo "Starting SDM"
  sdm --admin-token $SDM_ADMIN_TOKEN login
  sdm listen &
  ruby $FLUENTD_DIR/scripts/setup_streams.rb &
fi

echo "Creating Fluentd conf file"
ruby /create-conf.rb

echo "Starting Fluentd"
exec fluentd -c $FLUENTD_DIR/etc/fluent.conf -p $FLUENTD_DIR/plugins
