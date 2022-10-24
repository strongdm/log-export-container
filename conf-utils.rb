
require_relative './fluentd/scripts/dump_sdm_entities'

SUPPORTED_STORES = "stdout remote-syslog s3 cloudwatch splunk-hec datadog azure-loganalytics sumologic kafka mongo logz loki elasticsearch-8 bigquery"

def extract_value(str)
  unless str
    str = ""
  end
  str.gsub(/ /, "").downcase
end

def extract_entity_interval(entity)
  if entity == 'activities'
    extract_interval = extract_activities_interval
    return extract_interval ? "#{extract_interval}m" : ""
  end
  entity_interval_match = ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'].to_s.match /#{entity}\/(\d+)/
  interval = entity_interval_match ? entity_interval_match[1] : 480
  "#{interval}m"
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

def input_extract_audit_entities_conf(entity)
  extract_activities = extract_value(ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES'])
  extract_entities = extract_value(ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'])
  if entity == "activities" && extract_activities != "true" && !extract_entities.match(/activities/)
    return
  elsif entity != "activities" && !extract_entities.match(/#{entity}/)
    return
  end
  read_file = File.read("#{ETC_DIR}/input-extract-audit-entities.conf")
  read_file['$tag'] = AUDIT_ENTITY_TYPES[entity]
  read_file['$interval'] = extract_entity_interval(entity)
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
