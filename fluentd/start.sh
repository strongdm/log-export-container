#!/bin/sh

BASE_DIR=/fluentd/etc
INPUT=$BASE_DIR/input-rsyslog-csv.conf
PROCESS=$BASE_DIR/process.conf
OUTPUT=$BASE_DIR/output-s3.conf

cat $INPUT $PROCESS $OUTPUT > $BASE_DIR/fluent.conf
fluentd -c $BASE_DIR/fluent.conf 
