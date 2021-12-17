require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/output'
require 'open3'
require_relative '../helper'

ETC_DIR = './fluentd/etc'
SIGTERM = 15

class TestFluentAcceptance < Test::Unit::TestCase
  include Fluent::Test::Helpers
  include TestHelperModule

  def setup
    super
    Fluent::Test.setup

    generate_fluent_conf('syslog-json', 'stdout')
    _, @stdout, _, @fluent_thread = Open3.popen3("fluentd -c #{ETC_DIR}/fluent.conf -p ./fluentd/plugins")
    wait_for_fluent(@stdout)
    clear_buffer(@stdout)
  end

  def cleanup
    super

    Process.kill(SIGTERM, @fluent_thread.pid)
  end

  def test_json_start_log
    log = sample_start_log
    send_socket_message(create_log_message(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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
    send_socket_message(create_log_message(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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
    send_socket_message(create_log_message(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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
    send_socket_message(create_log_message(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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
    send_socket_message(create_log_message(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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
    wait_for_fluent(@stdout)
    clear_buffer(@stdout)
  end

  def cleanup
    super

    Process.kill(SIGTERM, @fluent_thread.pid)
  end

  def test_csv_start_log
    log = sample_start_log_csv
    send_socket_message(create_log_message_from_csv(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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
    send_socket_message(create_log_message_from_csv(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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
    send_socket_message(create_log_message_from_csv(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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
    send_socket_message(create_log_message_from_csv(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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
    send_socket_message(create_log_message_from_csv(log))
    output = @stdout.gets
    output = extract_valid_json_from_log(output)
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

def send_socket_message(message)
  client = TCPSocket.open('localhost', 5140)
  client.puts message
  client.close
end

def extract_valid_json_from_log(log)
  idx = log.index('{')
  if idx
    log = log[idx..-1]
  end
  JSON.parse(log)
end

def sample_start_log
  {
    "type" => "start",
    "timestamp" => "2021-06-23T00:00:00.000Z",
    "uuid" => "xxx",
    "datasourceId" => "rs-xxx",
    "datasourceName" => "datasource",
    "userId" => "a-000",
    "userName" => "User Name",
    "query" => "select 'b'",
    "hash" => "8964394d39ccb9667a0642e176bac17000000000"
  }
end

def sample_post_start_log
  {
    "type" => "postStart",
    "timestamp" => "2021-01-01T00:00:00.000Z",
    "uuid" => "xxx",
    "query" => "{version:1,width:114,height:24,duration:5.173268588,command:,title:null,env:{TERM:xterm-256color},type:shell,fileName:null,fileSize:0,stdout:null,lastChunkId:0,clientCommand:null,pod:null,container:null,requestMethod:,requestURI:,requestBody:null}\n",
    "hash" => "8964394d39ccb9667a0642e176bac17000000000"
  }
end

def sample_unclass_log
  {
    "type" => "unclass",
    "timestamp" => "2021-01-01T00:00:000Z",
    "uuid" => "xxx",
    "undef" => "1",
    "duration" => "329",
    "data" => "aGVsbG8gd29ybGQgaGVsbG8gd29ybGQgaGVsbG8gd29ybGQK"
  }
end

def sample_complete_log
  {
    "type" => "complete",
    "timestamp" => "2021-01-01T00:00:00.000Z",
    "uuid" => "XXX",
    "duration" => 0,
    "records" => 1
  }
end

def sample_start_log_csv
  {
    "1" => "2021-01-01T00:00:00Z",
    "2" => "start",
    "3" => "XXX",
    "4" => "rs-XXX",
    "5" => "datasourceName",
    "6" => "a-0000000000000000",
    "7" => "username",
    "8" => "select 'b'",
    "9" => "8964394d39ccb9667a0642e176bac17000000000"
  }
end

def sample_chunk_log_csv
  {
    '1' => '2021-01-01T00:00:00Z',
    '2' => 'chunk',
    '3' => 'XXX',
    '4' => '1',
    '5' => '0000000000000000000000000000000000000000',
    '6' => '8964394d39ccb9667a0642e176bac17000000000'
  }
end

def sample_complete_log_csv
  {
    "1" => "2021-01-01T00:00:00Z",
    "2" => "complete",
    "3" => "XXX",
    "4" => '0',
    "5" => '1'
  }
end

def sample_post_start_log_csv
  {
    "1" => "2021-01-01T00:00:00Z",
    "2" => "postStart",
    "3" => "XXX",
    "4" => '"{version:1,width:111,height:11,duration:1.0,command:,title:null,env:{TERM:xterm-256color},type:shell,fileName:null,fileSize:0,stdout:null,lastChunkId:0,clientCommand:null,pod:null,container:null,requestMethod:,requestURI:,requestBody:null}"',
    "5" => "8964394d39ccb9667a0642e176bac17000000000"
  }
end

def sample_event_log_csv
  {
    "1" => '2021-01-01T00:00:00Z',
    "2" => 'event',
    "3" => 'XXX',
    "4" => '1',
    "5" => '000',
    "6" => '8964394d39ccb9667a0642e176bac17000000000'
  }
end

def create_log_message(hash)
  "<5>2021-11-25T00:00:00Z ip-0-0-0-0 strongDM[734548]: #{JSON.generate(hash)}"
end

def create_log_message_from_csv(hash)
  "<5>#{hash.values.join(',')}"
end
