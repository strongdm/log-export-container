require 'json'
require 'date'
require 'open3'
require 'socket'

SIGTERM = 15

AUDIT_ENTITY_TYPES = {
  "activities" => "activity",
  "resources" => "resource",
  "users" => "user",
  "roles" => "role",
}

def get_audit_rows(entity_name)
  if entity_name == "activities"
    return get_audit_activities_rows
  end
  output = `sdm audit #{entity_name} -j`
  output.split("\n")
end

def get_audit_activities_rows
  interval_time = extract_activities_interval
  if interval_time == nil
    stream_activities
    return
  end
  datetime_from = DateTime.now - (interval_time + 1.0)/(24*60)
  datetime_to = DateTime.now - 1.0/(24*60)
  output = `sdm audit activities -j -e --from "#{datetime_from.to_s}" --to "#{datetime_to.to_s}"`
  output.split("\n")
end

def extract_activities_interval
  extract_entities = ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT']
  if ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'] != nil
    interval = ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'].to_i
  elsif extract_entities&.match /activities\/stream/
    return nil
  else
    interval_match = extract_entities&.match /activities\/+(\d+)/
    interval = interval_match ? interval_match[1].to_i : 15
  end
  interval
end

def stream_activities
  stdout_and_stderr, thread = open_activities_stream
  process_activity_stream(stdout_and_stderr)
  Process.kill(SIGTERM, thread.pid)
end

def open_activities_stream
  must_stream_json = ENV['LOG_EXPORT_CONTAINER_INPUT'].include?("json")
  command = "sdm audit activities -e -f"
  if must_stream_json
    command += " -j"
  end
  _, stdout_and_stderr, thread = Open3.popen2e(command)
  [stdout_and_stderr, thread]
end

def send_socket_message(message)
  client = TCPSocket.open('localhost', 5140)
  client.puts "<5>#{message}"
  client.close
end

def parse_entity(entity, entity_name)
  parsed_entity = JSON.parse(entity)
  parsed_entity['type'] = AUDIT_ENTITY_TYPES[entity_name]
  parsed_entity
end

def process_activity_stream(stdout)
  must_stream_json = ENV['LOG_EXPORT_CONTAINER_INPUT'].include?("json")
  stdout.each do |line|
    if must_stream_json
      message = JSON.generate(parse_entity(line, 'activities'))
    else
      message = line.gsub("\n", "") + ",activity"
    end
    send_socket_message(message)
  end
end

def parse_rows(rows, entity_name)
  parsed_rows = []
  rows.each do |row|
    parsed_rows << parse_entity(row, AUDIT_ENTITY_TYPES[entity_name])
  end
  parsed_rows
end

def print_rows(rows)
  rows.each { |row| puts "#{JSON.generate(row)}" }
end

def dump_entities(entity_name)
  unless AUDIT_ENTITY_TYPES.keys.include?(entity_name.to_s)
    return
  end
  begin
    rows = get_audit_rows(entity_name)
    unless rows
      return
    end
    parsed_rows = parse_rows(rows, entity_name)
    print_rows(parsed_rows)
  rescue StandardError => _e
    error = {"error" => "An error ocurred while extracting the audit #{entity_name.to_s} data: #{_e}", "type" => "unclass"}
    send_socket_message(JSON.generate(error))
  end
end

dump_entities(ARGV[0])
