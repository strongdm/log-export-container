require "open3"
require_relative './parse_entities'

VALID_ENTITIES = ["activities"]
ENTITY_PARSER = {
  "activities" => -> (item) {
    parse_activity(item)
  }
}

def stream_audit_data(entity_name)
  file_path = "./sdm-audit-#{entity_name}.log"
  File.new(file_path, "w")
  _, @stdout, _, @fluent_thread = Open3.popen3("sdm audit #{entity_name} -f -j")
  while output = @stdout.gets
    fn = ENTITY_PARSER[entity_name]
    parsed_output = fn.(output)
    File.open(file_path, "a") do |file|
      file.write("#{JSON.generate(parsed_output)}\n")
    end
  end
end

stream_entity_env = ENV["LOG_EXPORT_CONTAINER_STREAM_AUDIT_ENTITY"]
if stream_entity_env == nil
  return
end

stream_entity = stream_entity_env.downcase

if stream_entity != ""
  if VALID_ENTITIES.include? stream_entity
    stream_audit_data(stream_entity)
  else
    STDERR.puts "[ERROR] The defined stream entity is not valid."
  end
end
