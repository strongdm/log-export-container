#!/bin/sh

ETC_DIR=/fluentd/etc

get_intput_conf_name() {
    echo $1 | awk '{ gsub(/ /,""); print tolower($0) }'
}

get_output_conf_stores() {
    for s in stdout s3 cloudwatch splunk-hec datadog; do
        contains=$(echo $LOG_EXPORT_CONTAINER_OUTPUT | grep -wq $s; echo $?)
        if [ $contains -eq 0 ]; then
            export conf="$conf $s"
        fi
    done
    if [ "$conf" == "" ]; then
        echo "stdout"
    else
        echo $conf
    fi
}

get_input_conf_file() {
    conf=$(get_intput_conf_name $LOG_EXPORT_CONTAINER_INPUT)
    if [ "$conf" == "csv" ]; then
        echo $ETC_DIR/input-rsyslog-csv.conf
    else
        echo $ETC_DIR/input-rsyslog-json.conf
    fi
}

get_process_conf_file() {
    conf=$(get_intput_conf_name $LOG_EXPORT_CONTAINER_INPUT)
    if [ "$conf" == "csv" ]; then
        echo $ETC_DIR/process-csv.conf
    else
        echo $ETC_DIR/process-json.conf
    fi
}

get_output_conf() {
  new_line=""
  for s in $(get_output_conf_stores); do
    export stores="$stores$new_line$(cat $ETC_DIR/output-$s.conf)"
    if [ "$new_line" = "" ]; then
      new_line=$'\n'
    fi
  done
  envsubst < $ETC_DIR/output-template.conf
}

cat $(get_input_conf_file) $(get_process_conf_file) > $ETC_DIR/fluent.conf
echo "$(get_output_conf)" >> $ETC_DIR/fluent.conf
exec fluentd -c $ETC_DIR/fluent.conf -p /fluentd/plugins
