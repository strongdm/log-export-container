
SUPPORTED_STORES="stdout remote-syslog s3 cloudwatch splunk-hec datadog azure-loganalytics sumologic kafka mongo logz loki elasticsearch bigquery"
AUDIT_ENTITY_TYPES = {
  "resources" => "resource",
  "users" => "user",
  "roles" => "role",
}

def extract_value(str)
  unless str
    str = ""
  end
  str.gsub(/ /, "").downcase
end

def extract_entity_interval(entity, default_interval)
  treated_entity_list = ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'].to_s.match /#{entity}\/+(\d+)/
  if treated_entity_list != nil
    interval = treated_entity_list[1]
  else
    interval = default_interval
  end
  "#{interval}m"
end

def extract_activity_interval
  if ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'] != nil
    interval = "#{ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL']}m"
  else
    interval = extract_entity_interval("activities", "15")
  end
  interval
end

def monitoring_conf
  monitoring_enabled = extract_value(ENV['LOG_EXPORT_CONTAINER_ENABLE_MONITORING']) == "true"
  if monitoring_enabled
    File.read("#{ETC_DIR}/monitoring.conf")
  end
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
  extract_activities = extract_value(ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES'])
  extracted_entities = extract_value(ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'])
  unless extract_activities == "true" || extracted_entities.match(/activities/)
    return
  end
  read_file = File.read("#{ETC_DIR}/input-extract-audit-activities.conf")
  read_file['$interval'] = extract_activity_interval
  read_file
end

def input_extract_audit_entity_conf(entity)
  extract_audit = extract_value(ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'])
  unless extract_audit.match(/#{entity}/)
    return
  end
  read_file = File.read("#{ETC_DIR}/input-extract-audit-entity.conf")
  read_file['$tag'] = AUDIT_ENTITY_TYPES[entity]
  read_file['$interval'] = extract_entity_interval(entity, "480")
  read_file.gsub!("$entity", entity)
  read_file
end

def default_classify_conf
  conf = extract_value(ENV['LOG_EXPORT_CONTAINER_INPUT'])
  if conf == "syslog-csv" || conf == "tcp-csv" || conf == "file-csv"
    filename = "#{ETC_DIR}/classify-default-csv.conf"
  else
    filename = "#{ETC_DIR}/classify-default-json.conf"
  end
  File.read(filename)
end

def custom_classify_conf
  conf = extract_value(ENV['LOG_EXPORT_CONTAINER_INPUT'])
  if conf == "syslog-csv"
    File.read("#{ETC_DIR}/classify-syslog-csv.conf")
  elsif conf == "tcp-csv" || conf == "file-csv"
    File.read("#{ETC_DIR}/classify-tcp-csv.conf")
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
