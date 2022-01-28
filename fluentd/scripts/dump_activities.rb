require 'json'
require 'date'

def get_audit_activities
  extract_interval = ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'].to_i
  datetime_from = DateTime.now - (extract_interval + 1.0)/(24*60)
  datetime_to = DateTime.now - 1.0/(24*60)
  output = `/home/fluent/sdm audit activities -j -e --from "#{datetime_from.to_s}" --to "#{datetime_to.to_s}"`
  output.split("\n")
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
