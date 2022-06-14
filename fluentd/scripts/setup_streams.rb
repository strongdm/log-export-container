require "open3"
require_relative './parse_entities'

def stream_audit_data(entity_name)
  file_path = "#{ENV['FLUENTD_DIR']}/sdm-audit-#{entity_name}.log"
  File.new(file_path, "w")
  _, @stdout, _, @fluent_thread = Open3.popen3("sdm audit #{entity_name} -f -j")
  Thread.new {
    while (output = @stdout.gets)
      parsed_output = parse_entity(output, entity_name)
      File.open(file_path, "a") do |file|
        file.write("#{JSON.generate(parsed_output)}\n")
      end
    end
  }
end

stream_entities_env = ENV["LOG_EXPORT_CONTAINER_EXTRACT_AUDIT"]
if stream_entities_env == nil
  return
end

stream_entities = stream_entities_env.downcase.split

if stream_entities != ""
  thread_list = []
  stream_entities.each { |entity_name|
    match_stream = entity_name.match(/(.+)\/stream/)
    if match_stream == nil
      next
    elsif !valid_stream_entities.include?(match_stream[1])
      STDERR.puts "[WARN] The defined entity \"#{match_stream[1]}\" is not valid for streaming."
      next
    elsif match_stream[1] == "activities" && ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'] != nil
      next
    end
    thread_list << stream_audit_data(match_stream[1])
  }
  thread_list.each(&:join)
end
