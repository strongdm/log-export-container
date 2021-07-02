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
    elif [ "$conf" == "cloudwatch" ]; then
        echo $ETC_DIR/output-cloudwatch.conf
    elif [ "$conf" == "splunk-hec" ]; then
        echo $ETC_DIR/output-splunk-hec.conf
    elif [ "$conf" == "datadog" ]; then
        echo $ETC_DIR/output-datadog.conf
    else
        echo $ETC_DIR/output-stdout.conf
    fi
}

cat $(get_input_conf) $(get_process_conf) $(get_output_conf) > $ETC_DIR/fluent.conf
exec fluentd -c $ETC_DIR/fluent.conf -p /fluentd/plugins
