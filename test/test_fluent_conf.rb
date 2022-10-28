require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/output'
require_relative '../conf-utils'

class TestCreateFluentConfChangingInput < Test::Unit::TestCase
  include Fluent::Test::Helpers

  def setup
    Fluent::Test.setup
  end

  def cleanup
    super

    reset_environment_variables
  end

  def teardown
    super

    reset_environment_variables
  end

  def test_syslog_json_input_conf
    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_syslog_csv_input_conf
    fluent_conf_content = generate_fluent_conf('syslog-csv', 'stdout')
    assert_includes(fluent_conf_content, input_conf)
    assert_includes(fluent_conf_content, default_classify_conf)
    assert_includes(fluent_conf_content, custom_classify_conf)
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_tcp_json_input_conf
    fluent_conf = generate_fluent_conf('tcp-json', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_tcp_csv_input_conf
    fluent_conf = generate_fluent_conf('tcp-csv', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_tail_json_input_conf
    ENV['LOG_FILE_PATH'] = '/var/logs'
    fluent_conf = generate_fluent_conf('file-json', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_tail_csv_input_conf
    ENV['LOG_FILE_PATH'] = '/var/logs'
    fluent_conf = generate_fluent_conf('file-csv', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_audit_when_generate_activity_logs_using_the_default_interval
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES'] = 'true'
    expected = entity_conf('activity', '15m', 'activities')
    actual = input_extract_audit_entities_conf("activities")
    assert_equal(expected, actual)

    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_audit_when_generate_activity_logs_using_a_custom_interval
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES'] = 'true'
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'] = '20'
    expected = entity_conf('activity', '20m', 'activities')
    actual = input_extract_audit_entities_conf("activities")
    assert_equal(expected, actual)

    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_audit_when_activity_settings_overwrite_audit_settings
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES'] = 'true'
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'] = '20'
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'] = 'activities/10 resources/30 users/50 roles/60'

    expected_activities_conf = entity_conf('activity', '20m', 'activities')
    expected_resources_conf = entity_conf("resource", "30m", "resources")
    expected_users_conf = entity_conf("user", "50m", "users")
    expected_roles_conf = entity_conf("role", "60m", "roles")
    actual_activities_conf = input_extract_audit_entities_conf("activities")
    actual_resources_conf = input_extract_audit_entities_conf("resources")
    actual_users_conf = input_extract_audit_entities_conf("users")
    actual_roles_conf = input_extract_audit_entities_conf("roles")

    assert_equal(expected_activities_conf, actual_activities_conf)
    assert_equal(expected_resources_conf, actual_resources_conf)
    assert_equal(expected_users_conf, actual_users_conf)
    assert_equal(expected_roles_conf, actual_roles_conf)

    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_audit_when_there_are_multiple_entities_to_get_the_logs
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'] = 'activities/10 resources/20 users/30 roles/40'

    actual_activities_conf = input_extract_audit_entities_conf("activities")
    actual_resources_conf = input_extract_audit_entities_conf("resources")
    actual_users_conf = input_extract_audit_entities_conf("users")
    actual_roles_conf = input_extract_audit_entities_conf("roles")
    expected_activities_conf = entity_conf('activity', '10m', 'activities')
    expected_resources_conf = entity_conf("resource", "20m", "resources")
    expected_users_conf = entity_conf("user", "30m", "users")
    expected_roles_conf = entity_conf("role", "40m", "roles")

    assert_equal(expected_activities_conf, actual_activities_conf)
    assert_equal(expected_resources_conf, actual_resources_conf)
    assert_equal(expected_users_conf, actual_users_conf)
    assert_equal(expected_roles_conf, actual_roles_conf)

    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_audit_when_all_intervals_are_empty
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'] = 'activities/ resources/ users/ roles/'

    expected_activities_conf = entity_conf('activity', '15m', 'activities')
    expected_resources_conf = entity_conf("resource", "480m", "resources")
    expected_users_conf = entity_conf("user", "480m", "users")
    expected_roles_conf = entity_conf("role", "480m", "roles")
    actual_activities_conf = input_extract_audit_entities_conf("activities")
    actual_resources_conf = input_extract_audit_entities_conf("resources")
    actual_users_conf = input_extract_audit_entities_conf("users")
    actual_roles_conf = input_extract_audit_entities_conf("roles")

    assert_equal(expected_activities_conf, actual_activities_conf)
    assert_equal(expected_resources_conf, actual_resources_conf)
    assert_equal(expected_users_conf, actual_users_conf)
    assert_equal(expected_roles_conf, actual_roles_conf)

    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_fluent_conf_when_enabling_monitoring
    ENV['LOG_EXPORT_CONTAINER_ENABLE_MONITORING'] = 'true'

    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, monitoring_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_audit_when_stream_activities
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'] = 'activities/stream'

    expected_activities_conf = entity_conf('activity', '', 'activities')
    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')

    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, expected_activities_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_audit_when_stream_activities_and_activities_interval
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'] = 'activities/stream'
    ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'] = '1'

    expected_activities_conf = entity_conf('activity', '1m', 'activities')
    actual_activities_conf = input_extract_audit_entities_conf("activities")
    fluent_conf = generate_fluent_conf('syslog-json', 'stdout')

    assert_equal(expected_activities_conf, actual_activities_conf)
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, expected_activities_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end
end

class TestCreateFluentConfChangingOutput < Test::Unit::TestCase
  include Fluent::Test::Helpers

  def setup
    Fluent::Test.setup
  end

  def cleanup
    super

    reset_environment_variables
  end

  def test_remote_syslog_output_conf
    ENV['REMOTE_SYSLOG_HOST'] = '127.0.0.1'
    ENV['REMOTE_SYSLOG_PORT'] = '5140'
    ENV['REMOTE_SYSLOG_PROTOCOL'] = 'udp'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'remote-syslog')
    assert_includes(fluent_conf_content, input_conf)
    assert_includes(fluent_conf_content, default_classify_conf)
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_azure_loganalytics_output_conf
    ENV['AZURE_LOGANALYTICS_CUSTOMER_ID'] = 'AZURE_LOGANALYTICS_CUSTOMER_ID'
    ENV['AZURE_LOGANALYTICS_SHARED_KEY'] = 'AZURE_LOGANALYTICS_SHARED_KEY'
    fluent_conf = generate_fluent_conf('tcp-json', 'azure-loganalytics')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_cloudwatch_output_conf
    ENV['AWS_ACCESS_KEY_ID'] = 'AWS_ACCESS_KEY_ID'
    ENV['AWS_SECRET_ACCESS_KEY'] = 'AWS_SECRET_ACCESS_KEY'
    ENV['AWS_REGION'] = 'AWS_REGION'
    ENV['CLOUDWATCH_LOG_GROUP_NAME'] = 'CLOUDWATCH_LOG_GROUP_NAME'
    ENV['CLOUDWATCH_LOG_STREAM_NAME'] = 'CLOUDWATCH_LOG_STREAM_NAME'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'cloudwatch')
    assert_includes(fluent_conf_content, input_conf)
    assert_includes(fluent_conf_content, default_classify_conf)
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_datadog_output_conf
    ENV['HOSTNAME'] = 'HOSTNAME'
    ENV['DATADOG_API_KEY'] = 'DATADOG_API_KEY'
    fluent_conf = generate_fluent_conf('tcp-json', 'datadog')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_kafka_output_conf
    ENV['KAFKA_BROKERS'] = '0.0.0.0'
    ENV['KAFKA_TOPIC'] = 'KAFKA_TOPIC'
    ENV['KAFKA_FORMAT_TYPE'] = 'json'
    fluent_conf = generate_fluent_conf('tcp-json', 'kafka')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_s3_output_conf
    ENV['AWS_ACCESS_KEY_ID'] = 'AWS_ACCESS_KEY_ID'
    ENV['AWS_SECRET_ACCESS_KEY'] = 'AWS_SECRET_ACCESS_KEY'
    ENV['S3_BUCKET'] = 'S3_BUCKET'
    ENV['S3_REGION'] = 'S3_REGION'
    ENV['S3_PATH'] = 'S3_PATH'
    fluent_conf_content = generate_fluent_conf('tcp-json', 's3')
    assert_includes(fluent_conf_content, input_conf)
    assert_includes(fluent_conf_content, default_classify_conf)
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_splunk_hec_output_conf
    ENV['SPLUNK_HEC_HOST'] = 'SPLUNK_HEC_HOST'
    ENV['SPLUNK_HEC_PORT'] = 'SPLUNK_HEC_PORT'
    ENV['SPLUNK_HEC_TOKEN'] = 'SPLUNK_HEC_TOKEN'
    fluent_conf = generate_fluent_conf('tcp-json', 'splunk-hec')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_sumologic_output_conf
    ENV['SUMOLOGIC_ENDPOINT'] = 'http://0.0.0.0'
    ENV['SUMOLOGIC_SOURCE_CATEGORY'] = 'SUMOLOGIC_SOURCE_CATEGORY'
    fluent_conf = generate_fluent_conf('tcp-json', 'sumologic')
    assert_includes(fluent_conf, input_conf)
    assert_includes(fluent_conf, default_classify_conf)
    assert_includes(fluent_conf, process_conf)
    assert_includes(fluent_conf, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_mongo_output_conf
    ENV['MONGO_URI'] = 'mongodb://user:pass@localhost:27017/db'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'mongo')
    assert_includes(fluent_conf_content, input_conf)
    assert_includes(fluent_conf_content, default_classify_conf)
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_logz_output_conf
    ENV['LOGZ_ENDPOINT'] = 'https://listener.logz.io:8071?token=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&type=my_type'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'logz')
    assert_includes(fluent_conf_content, input_conf)
    assert_includes(fluent_conf_content, default_classify_conf)
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_loki_output_conf
    ENV['LOKI_URL'] = 'http://localhost:3100'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'loki')
    assert_includes(fluent_conf_content, input_conf)
    assert_includes(fluent_conf_content, default_classify_conf)
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_elasticsearch_output_conf
    ENV['ELASTICSEARCH_HOSTS'] = 'localhost:9201,https://user:pass@192.168.0.1:443'
    ENV['ELASTICSEARCH_INDEX_NAME'] = 'my-index'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'elasticsearch-8')
    assert_includes(fluent_conf_content, input_conf)
    assert_includes(fluent_conf_content, default_classify_conf)
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf)
    assert(is_valid_fluent_conf)
  end

  def test_bigquery_output_conf
    ENV['BIGQUERY_PRIVATE_KEY'] = '-----BEGIN PRIVATE KEY-----\n...'
    ENV['BIGQUERY_CLIENT_EMAIL'] = 'xxx@developer.gserviceaccount.com'
    ENV['BIGQUERY_PROJECT_ID'] = 'project-id'
    ENV['BIGQUERY_DATASET_ID'] = 'dataset_id'
    ENV['BIGQUERY_TABLE_ID'] = 'table_id'
    fluent_conf_content = generate_fluent_conf('tcp-json', 'bigquery')
    assert_includes(fluent_conf_content, input_conf)
    assert_includes(fluent_conf_content, default_classify_conf)
    assert_includes(fluent_conf_content, process_conf)
    assert_includes(fluent_conf_content, output_conf)
    assert(is_valid_fluent_conf)
  end
end

def generate_fluent_conf(input_type, output_type)
  ENV['LOG_EXPORT_CONTAINER_INPUT'] = input_type
  ENV['LOG_EXPORT_CONTAINER_OUTPUT'] = output_type
  ENV['FLUENTD_DIR'] = './fluentd'
  system('ruby ./create-conf.rb')
  read_fluentd_file('fluent.conf')
end

def process_conf
  read_fluentd_file('process.conf')
end

def read_fluentd_file(path)
  file = File.open(format("%s/%s", ETC_DIR, path))
  file.read
end

def is_valid_fluent_conf
  system("fluentd --dry-run -c #{ETC_DIR}/fluent.conf -p ./fluentd/plugins", :out => :close)
end

def reset_environment_variables
  ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES'] = nil
  ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT_ACTIVITIES_INTERVAL'] = nil
  ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'] = nil
  ENV['LOG_EXPORT_CONTAINER_ENABLE_MONITORING'] = nil
  ENV['REMOTE_SYSLOG_HOST'] = nil
  ENV['REMOTE_SYSLOG_PORT'] = nil
  ENV['REMOTE_SYSLOG_PROTOCOL'] = nil
  ENV['AZURE_LOGANALYTICS_CUSTOMER_ID'] = nil
  ENV['AZURE_LOGANALYTICS_SHARED_KEY'] = nil
  ENV['AWS_ACCESS_KEY_ID'] = nil
  ENV['AWS_SECRET_ACCESS_KEY'] = nil
  ENV['AWS_REGION'] = nil
  ENV['CLOUDWATCH_LOG_GROUP_NAME'] = nil
  ENV['CLOUDWATCH_LOG_STREAM_NAME'] = nil
  ENV['HOSTNAME'] = nil
  ENV['DATADOG_API_KEY'] = nil
  ENV['KAFKA_BROKERS'] = nil
  ENV['KAFKA_TOPIC'] = nil
  ENV['KAFKA_FORMAT_TYPE'] = nil
  ENV['AWS_ACCESS_KEY_ID'] = nil
  ENV['AWS_SECRET_ACCESS_KEY'] = nil
  ENV['S3_BUCKET'] = nil
  ENV['S3_REGION'] = nil
  ENV['S3_PATH'] = nil
  ENV['BIGQUERY_PRIVATE_KEY'] = nil
  ENV['BIGQUERY_CLIENT_EMAIL'] = nil
  ENV['BIGQUERY_PROJECT_ID'] = nil
  ENV['BIGQUERY_DATASET_ID'] = nil
  ENV['BIGQUERY_TABLE_ID'] = nil
  ENV['SPLUNK_HEC_HOST'] = nil
  ENV['SPLUNK_HEC_PORT'] = nil
  ENV['SPLUNK_HEC_TOKEN'] = nil
  ENV['SUMOLOGIC_ENDPOINT'] = nil
  ENV['SUMOLOGIC_SOURCE_CATEGORY'] = nil
  ENV['MONGO_URI'] = nil
  ENV['LOGZ_ENDPOINT'] = nil
  ENV['LOKI_URL'] = nil
  ENV['ELASTICSEARCH_HOSTS'] = nil
  ENV['ELASTICSEARCH_INDEX_NAME'] = nil
end

def entity_conf(tag, interval, entity)
  "<source>\n" \
  "  @type exec\n" \
  "  <parse>\n" \
  "    @type json\n" \
  "  </parse>\n" \
  "  tag #{tag}\n" \
  "  run_interval #{interval}\n" \
  "  command \"ruby \#{ENV['FLUENTD_DIR']}/scripts/dump_sdm_entities.rb #{entity}\"\n" \
  "</source>\n"
end
