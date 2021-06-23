#!/bin/sh

ETC_DIR=/fluentd/etc

get_conf() {
    echo $1 | awk '{ gsub(/ /,""); print tolower($0) }'
}

get_input_conf() {
    conf=$(get_conf $LOG_EXPORT_CONTAINER_INPUT)
    if [ "$conf" == "csv" ]; then
        echo $ETC_DIR/input-rsyslog-csv.conf
    else
        echo $ETC_DIR/input-rsyslog-json.conf
    fi
}

get_process_conf() {
    conf=$(get_conf $LOG_EXPORT_CONTAINER_INPUT)
    if [ "$conf" == "csv" ]; then
        echo $ETC_DIR/process-csv.conf
    else
        echo $ETC_DIR/process-json.conf
    fi
}

get_output_conf() {
    conf=$(get_conf $LOG_EXPORT_CONTAINER_OUTPUT)
    if [ "$conf" == "s3" ]; then
        echo $ETC_DIR/output-s3.conf
    else
        echo $ETC_DIR/output-stdout.conf
    fi
}

input_conf=$(get_input_conf)
process_conf=$(get_process_conf)
output_conf=$(get_output_conf)

cat $input_conf $process_conf $output_conf > $ETC_DIR/fluent.conf
exec fluentd -c $ETC_DIR/fluent.conf -p /fluentd/plugins
