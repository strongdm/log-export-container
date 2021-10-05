#! /bin/bash

bash ./create_conf_file.sh

fluentd -c $FLUENTD_DIR/etc/fluent.conf -p $FLUENTD_DIR/plugins
