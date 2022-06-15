require 'json'
require 'date'
require_relative './parse_entities'

def get_audit_activities
  interval_time = extract_activity_interval
  if interval_time == nil
    # Need to wait SDM to finish login before streaming
    system("sleep 1; sdm audit activities -f -j > /proc/1/fd/1 2>/proc/1/fd/2")
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
parsed_activities = parse_activities(activities)
print_activities(parsed_activities)
