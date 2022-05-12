require 'json'

def parse_activities(output_list)
  parsed_activities = []
  output_list.each do |item|
    parsed_activities << parse_activity(item)
  end
  parsed_activities
end

def parse_activity(item)
  activity = JSON.parse(item)
  activity['type'] = 'activity'
  activity
end
