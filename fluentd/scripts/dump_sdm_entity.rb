require 'json'
require 'date'
require_relative './dump_utils'

ENTITY_TYPES = {
  "resources" => "resource",
  "users" => "user",
  "roles" => "role",
}

def entity_name_argument
  ARGV[0]
end

def get_audit_rows
  error_file_path = "/var/log/sdm-audit-#{entity_name_argument}-errors.log"
  output = backoff_retry(-> () {
    `sdm audit #{entity_name_argument} -j 2> #{error_file_path}`
  }, entity_name_argument, error_file_path)
  unless output
    return
  end
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
