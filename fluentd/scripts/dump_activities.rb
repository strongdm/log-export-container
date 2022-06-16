require 'json'
require 'date'
require 'open3'
require 'socket'
require_relative './parse_entities'

SIGTERM = 15

def open_activities_stream
  must_stream_json = ENV['LOG_EXPORT_CONTAINER_INPUT'].include?("json")
  command = "sdm audit activities -f"
  if must_stream_json
    command += " -j"
  end
  _, out, _, thread = Open3.popen3(command)
  [out, thread]
end

def send_socket_message(message)
  client = TCPSocket.open('localhost', 5140)
  client.puts "<5>#{message}"
  client.close
end

def process_activity_stream(stdout)
  must_stream_json = ENV['LOG_EXPORT_CONTAINER_INPUT'].include?("json")
  while (line = stdout.readline)
    if must_stream_json
      message = JSON.generate(parse_entity(line, 'activities'))
    else
      message = line.gsub("\n", "") + ",activity"
    end
    send_socket_message(message)
  end
end

def stream_activities
  # Need to wait SDM to finish login before streaming
  system("sleep 1")
  stdout, thread = open_activities_stream
  process_activity_stream(stdout)
  Process.kill(SIGTERM, thread.pid)
end

def get_audit_activities
  interval_time = extract_activity_interval
  if interval_time == nil
    stream_activities
    return
  end
  datetime_from = DateTime.now - (interval_time + 1.0)/(24*60)
  datetime_to = DateTime.now - 1.0/(24*60)
  output = `sdm audit activities -j -e --from "#{datetime_from.to_s}" --to "#{datetime_to.to_s}"`
  output.split("\n")
end

def extract_activity_interval
  extract_entities = ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'].downcase
  if ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'] != nil
    interval = ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'].to_i
  elsif extract_entities.match /activities\/stream/
    return nil
  else
    interval = (extract_entities.match /activities\/+(\d+)/)[1].to_i || 15
  end
  interval
end

def print_activities(activities)
  activities.each { |activity| puts "#{JSON.generate(activity)}" }
end

activities = get_audit_activities
if activities == nil
  return
end
parsed_activities = parse_activities(activities)
print_activities(parsed_activities)
