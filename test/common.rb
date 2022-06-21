
SIGTERM = 15

def generate_fluent_conf(input_type, output_type)
  ENV['LOG_EXPORT_CONTAINER_INPUT'] = input_type
  ENV['LOG_EXPORT_CONTAINER_OUTPUT'] = output_type
  ENV['FLUENTD_DIR'] = './fluentd'
  system('ruby ./create-conf.rb')
  read_fluentd_file('fluent.conf')
end

def read_fluentd_file(path)
  file = File.open(format("%s/%s", ETC_DIR, path))
  file.read
end

def wait_for_fluent(stdout)
  while (line = stdout.gets) do
    break if line.include?('is now running worker')
  end
end

def clear_buffer(stdout)
  stdout.gets
  stdout.gets
  stdout.gets
end
