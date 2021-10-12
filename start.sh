#!/bin/sh

sh ./create-conf-file.sh
exec fluentd -c $FLUENTD_DIR/etc/fluent.conf -p $FLUENTD_DIR/plugins
