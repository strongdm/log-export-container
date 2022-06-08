require 'json'
require 'date'

ENTITY_TYPES = {
  "resources" => "resource",
  "users" => "user",
  "roles" => "role",
}

def entity_name_argument
  ARGV[0]
end

def get_audit_rows
  output = `sdm audit #{entity_name_argument} -j`
  output.split("\n")
end

def parse_rows(output_list)
  parsed_rows = []
  output_list.each do |item|
    row = JSON.parse(item)
    row['type'] = ENTITY_TYPES[entity_name_argument]
    parsed_rows << row
  end
  parsed_rows
end

def print_rows(rows)
  rows.each { |row| puts "#{JSON.generate(row)}" }
end

rows = get_audit_rows
parsed_rows = parse_rows(rows)
print_rows(parsed_rows)
