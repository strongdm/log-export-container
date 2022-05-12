#!/bin/sh

if [ "$SDM_ADMIN_TOKEN" != "" ]; then
  echo "Starting SDM"
  cd /home/fluent
  ./sdm --admin-token $SDM_ADMIN_TOKEN login
  ./sdm listen &
  cd /

  ruby $FLUENTD_DIR/scripts/setup-streams.rb &
fi

echo "Creating Fluentd conf file"
ruby ./create-conf.rb

echo "Starting Fluentd"
exec fluentd -c $FLUENTD_DIR/etc/fluent.conf -p $FLUENTD_DIR/plugins
