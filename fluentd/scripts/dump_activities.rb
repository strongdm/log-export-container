require 'json'
require 'date'

def get_audit_activities
  interval_time = extract_activity_interval
  datetime_from = DateTime.now - (interval_time + 1.0)/(24*60)
  datetime_to = DateTime.now - 1.0/(24*60)
  output = `sdm audit activities -j -e --from "#{datetime_from.to_s}" --to "#{datetime_to.to_s}"`
  output.split("\n")
end

def extract_activity_interval
  if ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'] != nil
    interval = ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'].to_i
  else
    interval = (ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'].match /activities\/+(\d+)/)[1].to_i || 15
  end
  interval
end

def parse_activities(output_list)
  parsed_activities = []
  output_list.each do |item|
    activity = JSON.parse(item)
    activity['type'] = 'activity'
    parsed_activities << activity
  end
  parsed_activities
end

def print_activities(activities)
  activities.each { |activity| puts "#{JSON.generate(activity)}" }
end

activities = get_audit_activities
parsed_activities = parse_activities(activities)
print_activities(parsed_activities)
