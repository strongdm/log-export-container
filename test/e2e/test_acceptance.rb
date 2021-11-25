require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/output'
require 'open3'
require_relative '../helper'

ETC_DIR = './fluentd/etc'

class TestFluentAcceptance < Test::Unit::TestCase
  include Fluent::Test::Helpers
  include TestHelperModule

  def setup
    super
    Fluent::Test.setup

    generate_fluent_conf('syslog-json', 'stdout')
    _, @stdout, _, @fluent_thread = Open3.popen3("fluentd -c #{ETC_DIR}/fluent.conf -p ./fluentd/plugins")
    while line = @stdout.gets do
      break if line.include?('is now running worker')
    end

    next_line_output_message
    next_line_output_message
    next_line_output_message
  end

  def cleanup
    super

    Process.kill(15, @fluent_thread.pid)
  end

  def next_line_output_message
    @stdout.gets
  end

  def send_message(message)
    client = TCPSocket.open('localhost', 5140)
    client.puts message
    client.close
  end

  def extract_log_json(log)
    idx = log.index('{')
    if idx
      log = log[idx..-1]
    end
    JSON.parse log.gsub('=>', ':')
  end

  def test_json_start_log
    log = sample_start_log
    send_message(create_log_message(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['type'], output['type'])
    assert_equal(log['timestamp'], output['timestamp'])
    assert_equal(log['uuid'], output['uuid'])
    assert_equal(log['datasourceId'], output['datasourceId'])
    assert_equal(log['datasourceName'], output['datasourceName'])
    assert_equal(log['userId'], output['userId'])
    assert_equal(log['userName'], output['userName'])
    assert_equal(log['query'], output['query'])
    assert_equal(log['hash'], output['hash'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end

  def test_json_chunk_log
    log = sample_chunk_log
    send_message(create_log_message(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['type'], output['type'])
    assert_equal(log['timestamp'], output['timestamp'])
    assert_equal(log['uuid'], output['uuid'])
    assert_equal(log['chunkId'], output['chunkId'])
    assert_equal(log['events'], output['events'])
    assert_equal(log['hash'], output['hash'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end

  def test_json_post_start_log
    log = sample_post_start_log
    send_message(create_log_message(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['type'], output['type'])
    assert_equal(log['timestamp'], output['timestamp'])
    assert_equal(log['uuid'], output['uuid'])
    assert_equal(log['query'], output['query'])
    assert_equal(log['hash'], output['hash'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end

  def test_json_unclass_log
    log = sample_unclass_log
    send_message(create_log_message(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['type'], output['type'])
    assert_equal(log['timestamp'], output['timestamp'])
    assert_equal(log['uuid'], output['uuid'])
    assert_equal(log['records'], output['records'])
    assert_equal(log['duration'], output['duration'])
    assert_equal(log['hash'], output['hash'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end

  def test_json_complete_log
    log = sample_complete_log
    send_message(create_log_message(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['type'], output['type'])
    assert_equal(log['timestamp'], output['timestamp'])
    assert_equal(log['uuid'], output['uuid'])
    assert_equal(log['duration'], output['duration'])
    assert_equal(log['records'], output['records'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end
end

class TestFluentCSVAcceptance < Test::Unit::TestCase
  include Fluent::Test::Helpers
  include TestHelperModule

  def setup
    super
    Fluent::Test.setup

    generate_fluent_conf('syslog-csv', 'stdout')
    _, @stdout, _, @fluent_thread = Open3.popen3("fluentd -c #{ETC_DIR}/fluent.conf -p ./fluentd/plugins")
    while line = @stdout.gets do
      break if line.include?('is now running worker')
    end

    next_line_output_message
    next_line_output_message
    next_line_output_message
  end

  def cleanup
    super

    Process.kill(15, @fluent_thread.pid)
  end

  def send_message(message)
    client = TCPSocket.open('localhost', 5140)
    client.puts message
    client.close
  end

  def extract_log_json(log)
    idx = log.index('{')
    if idx
      log = log[idx..-1]
    end
    JSON.parse log.gsub('=>', ':').gsub('nil', 'null')
  end

  def next_line_output_message
    @stdout.gets
  end

  def test_csv_start_log
    log = sample_start_log_csv
    send_message(create_log_message_from_csv(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['1'], output['timestamp'])
    assert_equal(log['2'], output['type'])
    assert_equal(log['3'], output['uuid'])
    assert_equal(log['4'], output['datasourceId'])
    assert_equal(log['5'], output['datasourceName'])
    assert_equal(log['6'], output['userId'])
    assert_equal(log['7'], output['userName'])
    assert_equal(log['8'], output['query'])
    assert_equal(log['9'], output['hash'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end

  def test_csv_chunk_log
    log = sample_chunk_log_csv
    send_message(create_log_message_from_csv(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['1'], output['timestamp'])
    assert_equal(log['2'], output['type'])
    assert_equal(log['3'], output['uuid'])
    assert_equal(log['4'], output['chunkId'])
    assert_equal(log['5'], output['events'])
    assert_equal(log['6'], output['hash'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end

  def test_csv_post_start_log
    log = sample_post_start_log_csv
    send_message(create_log_message_from_csv(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['1'], output['timestamp'])
    assert_equal(log['2'], output['type'])
    assert_equal(log['3'], output['uuid'])
    assert_equal(log['4'].gsub("\"", ""), output['query'])
    assert_equal(log['5'], output['hash'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end

  def test_csv_unclass_log
    log = sample_event_log_csv
    send_message(create_log_message_from_csv(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['1'], output['timestamp'])
    assert_equal(log['2'], output['type'])
    assert_equal(log['3'], output['uuid'])
    assert_equal(log['4'], output['undef'])
    assert_equal(log['5'], output['duration'])
    assert_equal(log['6'], output['data'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end

  def test_csv_complete_log
    log = sample_complete_log_csv
    send_message(create_log_message_from_csv(log))
    output = next_line_output_message
    output = extract_log_json(output)
    assert_equal(log['1'], output['timestamp'])
    assert_equal(log['2'], output['type'])
    assert_equal(log['3'], output['uuid'])
    assert_equal(log['4'], output['duration'])
    assert_equal(log['5'], output['records'])
    assert_not_nil(output['sourceAddress'])
    assert_not_nil(output['sourceHostname'])
  end
end

def generate_fluent_conf(input_type, output_type)
  ENV['LOG_EXPORT_CONTAINER_INPUT'] = input_type
  ENV['LOG_EXPORT_CONTAINER_OUTPUT'] = output_type
  ENV['FLUENTD_DIR'] = './fluentd'
  system('bash ./create-conf-file.sh')
  read_fluentd_file('fluent.conf')
end

def read_fluentd_file(path)
  file = File.open(format("%s/%s", ETC_DIR, path))
  file.read
end
