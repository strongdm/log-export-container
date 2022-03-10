
ETC_DIR="#{ENV['FLUENTD_DIR']}/etc"
SUPPORTED_STORES="stdout remote-syslog s3 cloudwatch splunk-hec datadog azure-loganalytics sumologic kafka mongo logz loki elasticsearch"

def extract_value(str)
  unless str
    str = ""
  end
  str.gsub(/ /, "").downcase
end

def output_stores_conf
  conf = ""
  output_types = extract_value(ENV['LOG_EXPORT_CONTAINER_OUTPUT'])
  stores = SUPPORTED_STORES.split(' ')
  stores.each do |store|
    if output_types.include?(store)
      conf = "#{conf}#{store} "
    end
  end
  if conf == ""
    return "stdout"
  end
  conf
end

def input_conf
  conf = extract_value(ENV['LOG_EXPORT_CONTAINER_INPUT'])
  if conf != ""
    filename = "#{ETC_DIR}/input-#{conf}.conf"
  else
    filename = "#{ETC_DIR}/input-syslog-json.conf"
  end
  File.read(filename)
end

def decode_chunk_events_conf
  conf = extract_value(ENV['LOG_EXPORT_CONTAINER_INPUT'])
  decode_chunks_enabled = extract_value(ENV['LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS']) == "true"
  if (conf == "syslog-json" || conf == "tcp-json") && decode_chunks_enabled
    File.read("#{ETC_DIR}/input-json-chunk.conf")
  end
end

def input_extract_audit_activities_conf
  extract_enabled = extract_value(ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES']) == "true"
  if extract_enabled
    File.read("#{ETC_DIR}/input-extract-audit-activities.conf")
  end
end

def default_classify_conf
  conf = extract_value(ENV['LOG_EXPORT_CONTAINER_INPUT'])
  if conf == "syslog-csv" || conf == "tcp-csv" || conf == "tail-csv"
    filename = "#{ETC_DIR}/classify-default-csv.conf"
  else
    filename = "#{ETC_DIR}/classify-default-json.conf"
  end
  File.read(filename)
end

def custom_classify_conf
  conf = extract_value(ENV['LOG_EXPORT_CONTAINER_INPUT'])
  if conf == "syslog-csv" || conf == "tcp-csv" || conf == "tail-csv"
    File.read("#{ETC_DIR}/classify-#{conf}.conf")
  end
end

def output_conf
  output_content = []
  stores = output_stores_conf.split(' ')
  stores.each do |store|
    output_content << File.read("#{ETC_DIR}/output-#{store}.conf")
  end
  template = File.read("#{ETC_DIR}/output-template.conf")
  template["$stores"] = output_content.join("")
  template
end

def create_file
  File.open("#{ETC_DIR}/fluent.conf", "w") do |f|
    f.write(input_conf)
    f.write(input_extract_audit_activities_conf)
    f.write(default_classify_conf)
    f.write(custom_classify_conf)
    f.write(File.read("#{ETC_DIR}/process.conf"))
    f.write(decode_chunk_events_conf)
    f.write(output_conf)
  end
end

create_file
