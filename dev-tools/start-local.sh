#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export FLUENTD_DIR="$SCRIPT_DIR/../fluentd"

ruby $SCRIPT_DIR/../create-conf.rb
fluentd -c $FLUENTD_DIR/../fluentd/etc/fluent.conf -p $FLUENTD_DIR/../fluentd/plugins &

ssh -N -R 5140:localhost:5140 -i $LOG_EXPORT_CONTAINER_SSH_CREDENTIALS $LOG_EXPORT_CONTAINER_SSH_DESTINATION
