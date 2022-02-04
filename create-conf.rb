
ETC_DIR="#{ENV['FLUENTD_DIR']}/etc"
SUPPORTED_STORES="stdout s3 cloudwatch splunk-hec datadog azure-loganalytics sumologic kafka mongo logz"

def input_conf_name(input_type = "")
  input_type.gsub(/ /, "").downcase
end

def output_conf_stores
  conf = ""
  output_types = ENV['LOG_EXPORT_CONTAINER_OUTPUT'] || ""
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
  conf = input_conf_name ENV['LOG_EXPORT_CONTAINER_INPUT']
  if conf != ""
    filename = "#{ETC_DIR}/input-#{conf}.conf"
  else
    filename = "#{ETC_DIR}/input-syslog-json.conf"
  end
  File.read(filename)
end

def input_chunk_conf
  conf = input_conf_name ENV['LOG_EXPORT_CONTAINER_INPUT']
  decode_chunks_enabled = (ENV['LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS'] || "").downcase == "true"
  if (conf == "syslog-json" || conf == "tcp-json") && decode_chunks_enabled
    File.read("#{ETC_DIR}/input-json-chunk.conf")
  end
end

def input_extract_audit_activities
  extract_enabled = (ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES'] || "").downcase == "true"
  if extract_enabled
    File.read("#{ETC_DIR}/input-extract-audit-activities.conf")
  end
end

def classify_conf
  conf = input_conf_name ENV['LOG_EXPORT_CONTAINER_INPUT']
  if conf == "syslog-csv" || conf == "tcp-csv"
    filename = "#{ETC_DIR}/classify-default-csv.conf"
  else
    filename = "#{ETC_DIR}/classify-default-json.conf"
  end
  File.read(filename)
end

def custom_classify_conf
  conf = input_conf_name ENV['LOG_EXPORT_CONTAINER_INPUT']
  if conf == "syslog-csv" || conf == "tcp-csv"
    File.read("#{ETC_DIR}/classify-#{conf}.conf")
  end
end

def output_file(type)
  File.read("#{ETC_DIR}/output-#{type}.conf")
end

def output_conf
  output_content = []
  stores = output_conf_stores.split(' ')
  stores.each do |store|
    output_content << output_file(store)
  end
  template = File.read("#{ETC_DIR}/output-template.conf")
  template["$stores"] = output_content.join("")
  template
end

def create_file
  File.open("#{ETC_DIR}/fluent.conf", "w") do |f|
    f.write(input_conf)
    f.write(input_extract_audit_activities)
    f.write(classify_conf)
    f.write(custom_classify_conf)
    f.write(File.read("#{ETC_DIR}/process.conf"))
    f.write(input_chunk_conf)
    f.write(output_conf)
  end
end

create_file
