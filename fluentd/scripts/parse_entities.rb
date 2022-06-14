require 'json'

ENTITY_PARSER = {
  'activities' => -> (item) {
    parse_entity_with_type(item, 'activity')
  }
}

def parse_activities(output_list)
  parsed_activities = []
  output_list.each do |item|
    parsed_activities << parse_entity_with_type(item, 'activity')
  end
  parsed_activities
end

def parse_entity_with_type(entity, type)
  parsed_entity = JSON.parse(entity)
  parsed_entity['type'] = type
  parsed_entity
end

def parse_entity(item, entity_name)
  ENTITY_PARSER[entity_name].(item)
end

def valid_stream_entities
  ENTITY_PARSER.keys
end
