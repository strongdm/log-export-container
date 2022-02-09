require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/output'

ETC_DIR = './fluentd/etc'

class TestCreateFluentConfChangingInput < Test::Unit::TestCase
  include Fluent::Test::Helpers

  def setup
    Fluent::Test.setup
  end

  def test_syslog_json_input_conf
    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')
    assert_includes(fluent_conf, input_conf('syslog-json'))
    assert_includes(fluent_conf, default_classify_conf('json'))
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf('stdout'))
    assert(is_valid_fluent_conf)
  end

  def test_syslog_csv_input_conf
    fluent_conf_content = generate_fluent_conf('syslog-csv', 'stdout')
    assert_includes(fluent_conf_content, input_conf('syslog-csv'))
    assert_includes(fluent_conf_content, default_classify_conf('csv'))
    assert_includes(fluent_conf_content, classify_conf('syslog-csv'))
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf('stdout'))
    assert(is_valid_fluent_conf)
  end

  def test_tcp_json_input_conf
    fluent_conf = generate_fluent_conf('tcp-json', 'stdout')
    assert_includes(fluent_conf, input_conf('tcp-json'))
    assert_includes(fluent_conf, default_classify_conf('json'))
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf('stdout'))
    assert(is_valid_fluent_conf)
  end

  def test_tcp_csv_input_conf
    fluent_conf = generate_fluent_conf('tcp-csv', 'stdout')
    assert_includes(fluent_conf, input_conf('tcp-csv'))
    assert_includes(fluent_conf, default_classify_conf('csv'))
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf('stdout'))
    assert(is_valid_fluent_conf)
  end
end

class TestCreateFluentConfChangingOutput < Test::Unit::TestCase
  include Fluent::Test::Helpers

  def setup
    Fluent::Test.setup
  end

  def test_azure_loganalytics_output_conf
    ENV['AZURE_LOGANALYTICS_CUSTOMER_ID'] = 'AZURE_LOGANALYTICS_CUSTOMER_ID'
    ENV['AZURE_LOGANALYTICS_SHARED_KEY'] = 'AZURE_LOGANALYTICS_SHARED_KEY'
    fluent_conf = generate_fluent_conf('tcp-json', 'azure-loganalytics')
    assert_includes(fluent_conf, input_conf('tcp-json'))
    assert_includes(fluent_conf, default_classify_conf('json'))
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf('azure-loganalytics'))
    assert(is_valid_fluent_conf)
  end

  def test_cloudwatch_output_conf
    ENV['AWS_ACCESS_KEY_ID'] = 'AWS_ACCESS_KEY_ID'
    ENV['AWS_SECRET_ACCESS_KEY'] = 'AWS_SECRET_ACCESS_KEY'
    ENV['AWS_REGION'] = 'AWS_REGION'
    ENV['CLOUDWATCH_LOG_GROUP_NAME'] = 'CLOUDWATCH_LOG_GROUP_NAME'
    ENV['CLOUDWATCH_LOG_STREAM_NAME'] = 'CLOUDWATCH_LOG_STREAM_NAME'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'cloudwatch')
    assert_includes(fluent_conf_content, input_conf('tcp-json'))
    assert_includes(fluent_conf_content, default_classify_conf('json'))
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf('cloudwatch'))
    assert(is_valid_fluent_conf)
  end

  def test_datadog_output_conf
    ENV['HOSTNAME'] = 'HOSTNAME'
    ENV['DATADOG_API_KEY'] = 'DATADOG_API_KEY'
    fluent_conf = generate_fluent_conf('tcp-json', 'datadog')
    assert_includes(fluent_conf, input_conf('tcp-json'))
    assert_includes(fluent_conf, default_classify_conf('json'))
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf('datadog'))
    assert(is_valid_fluent_conf)
  end

  def test_kafka_output_conf
    ENV['KAFKA_BROKERS'] = '0.0.0.0'
    ENV['KAFKA_TOPIC'] = 'KAFKA_TOPIC'
    ENV['KAFKA_FORMAT_TYPE'] = 'json'
    fluent_conf = generate_fluent_conf('tcp-json', 'kafka')
    assert_includes(fluent_conf, input_conf('tcp-json'))
    assert_includes(fluent_conf, default_classify_conf('json'))
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf('kafka'))
    assert(is_valid_fluent_conf)
  end

  def test_s3_output_conf
    ENV['AWS_ACCESS_KEY_ID'] = 'AWS_ACCESS_KEY_ID'
    ENV['AWS_SECRET_ACCESS_KEY'] = 'AWS_SECRET_ACCESS_KEY'
    ENV['S3_BUCKET'] = 'S3_BUCKET'
    ENV['S3_REGION'] = 'S3_REGION'
    ENV['S3_PATH'] = 'S3_PATH'
    fluent_conf_content = generate_fluent_conf('tcp-json', 's3')
    assert_includes(fluent_conf_content, input_conf('tcp-json'))
    assert_includes(fluent_conf_content, default_classify_conf('json'))
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf('s3'))
    assert(is_valid_fluent_conf)
  end

  def test_splunk_hec_output_conf
    ENV['SPLUNK_HEC_HOST'] = 'SPLUNK_HEC_HOST'
    ENV['SPLUNK_HEC_PORT'] = 'SPLUNK_HEC_PORT'
    ENV['SPLUNK_HEC_TOKEN'] = 'SPLUNK_HEC_TOKEN'
    fluent_conf = generate_fluent_conf('tcp-json', 'splunk-hec')
    assert_includes(fluent_conf, input_conf('tcp-json'))
    assert_includes(fluent_conf, default_classify_conf('json'))
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf('splunk-hec'))
    assert(is_valid_fluent_conf)
  end

  def test_sumologic_output_conf
    ENV['SUMOLOGIC_ENDPOINT'] = 'http://0.0.0.0'
    ENV['SUMOLOGIC_SOURCE_CATEGORY'] = 'SUMOLOGIC_SOURCE_CATEGORY'
    fluent_conf = generate_fluent_conf('tcp-json', 'sumologic')
    assert_includes(fluent_conf, input_conf('tcp-json'))
    assert_includes(fluent_conf, default_classify_conf('json'))
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf('sumologic'))
    assert(is_valid_fluent_conf)
  end

  def test_mongo_output_conf
    ENV['MONGO_URI'] = 'mongodb://user:pass@localhost:27017/db'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'mongo')
    assert_includes(fluent_conf_content, input_conf('tcp-json'))
    assert_includes(fluent_conf_content, default_classify_conf('json'))
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf('mongo'))
    assert(is_valid_fluent_conf)
  end

  def test_logz_output_conf
    ENV['LOGZ_ENDPOINT'] = 'https://listener.logz.io:8071?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&type=my_type'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'logz')
    assert_includes(fluent_conf_content, input_conf('tcp-json'))
    assert_includes(fluent_conf_content, default_classify_conf('json'))
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf('logz'))
    assert(is_valid_fluent_conf)
  end

  def test_loki_output_conf
    ENV['LOKI_URL'] = 'http://localhost:3100'
    ENV['LOKI_USERNAME'] = 'admin'
    ENV['LOKI_PASSWORD'] = 'admin'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'loki')
    assert_includes(fluent_conf_content, input_conf('tcp-json'))
    assert_includes(fluent_conf_content, default_classify_conf('json'))
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf('loki'))
    assert(is_valid_fluent_conf)
  end
end

def generate_fluent_conf(input_type, output_type)
  ENV['LOG_EXPORT_CONTAINER_INPUT'] = input_type
  ENV['LOG_EXPORT_CONTAINER_OUTPUT'] = output_type
  ENV['FLUENTD_DIR'] = './fluentd'
  system('bash ./create-conf-file.sh')
  read_fluentd_file('fluent.conf')
end

def input_conf(type)
  read_fluentd_file(format("input-%s.conf", type))
end

def default_classify_conf(type)
  read_fluentd_file(format("classify-default-%s.conf", type))
end

def classify_conf(type)
  read_fluentd_file(format("classify-%s.conf", type))
end

def process_conf
  read_fluentd_file('process.conf')
end

def output_conf(type)
  read_fluentd_file(format("output-%s.conf", type))
end

def read_fluentd_file(path)
  file = File.open(format("%s/%s", ETC_DIR, path))
  file.read
end

def is_valid_fluent_conf
  system("fluentd --dry-run -c #{ETC_DIR}/fluent.conf -p ./fluentd/plugins", :out => :close)
end
