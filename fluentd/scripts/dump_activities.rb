require 'json'
require 'date'
require_relative './parse_entities'
require_relative './dump_utils'

def get_audit_activities
  interval_time = extract_activity_interval
  datetime_from = DateTime.now - (interval_time + 1.0)/(24*60)
  error_file_path = "/var/log/sdm-audit-activities-errors.log"
  output = backoff_retry(-> () {
    datetime_to = DateTime.now - 1.0/(24*60)
    `sdm audit activities -j -e --from "#{datetime_from.to_s}" --to "#{datetime_to.to_s}" 2> #{error_file_path}`
  }, "activities", error_file_path)
  unless output
    return
  end
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

def print_activities(activities)
  activities.each { |activity| puts "#{JSON.generate(activity)}" }
end

activities = get_audit_activities
unless activities
  return
end
parsed_activities = parse_activities(activities)
print_activities(parsed_activities)
