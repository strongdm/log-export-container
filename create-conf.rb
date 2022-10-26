
ETC_DIR="#{ENV['FLUENTD_DIR']}/etc"

require_relative './conf-utils'

def create_file
  File.open("#{ETC_DIR}/fluent.conf", "w") do |f|
    f.write(input_conf)
    f.write(monitoring_conf)
    AUDIT_ENTITY_TYPES.keys.each { |entity_name|
      f.write(input_extract_audit_entities_conf(entity_name))
    }
    f.write(default_classify_conf)
    f.write(custom_classify_conf)
    f.write(File.read("#{ETC_DIR}/process.conf"))
    f.write(decode_chunk_events_conf)
    f.write(output_conf)
  end
end

create_file
