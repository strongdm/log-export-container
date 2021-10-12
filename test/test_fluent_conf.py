import os
import pytest

# Run tests from the project's root dir 
ETC_DIR = './fluentd/etc'

@pytest.fixture(autouse=True)
def run_around_tests():
    yield
    os.remove(f'{ETC_DIR}/fluent.conf')

# TODO At some point we might want to validate the sequence in fluentd.conf
class TestCreateFluentConfChangingInput:
    def test_create_syslog_json_conf(self, monkeypatch):
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'syslog-json', 'stdout')
        assert get_input_conf('syslog-json') in fluent_conf_content
        assert get_default_classify_conf('json') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('stdout') in fluent_conf_content
        assert is_valid_fluent_conf()

    def test_create_syslog_csv_conf(self, monkeypatch):
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'syslog-csv', 'stdout')
        assert get_input_conf('syslog-csv') in fluent_conf_content
        assert get_default_classify_conf('csv') in fluent_conf_content
        assert get_custom_classify_conf('syslog-csv') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('stdout') in fluent_conf_content
        assert is_valid_fluent_conf()

    def test_create_tcp_json_conf(self, monkeypatch):
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'tcp-json', 'stdout')
        assert get_input_conf('tcp-json') in fluent_conf_content
        assert get_default_classify_conf('json') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('stdout') in fluent_conf_content
        assert is_valid_fluent_conf()

    def test_create_tcp_csv_conf(self, monkeypatch):
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'tcp-csv', 'stdout')
        assert get_input_conf('tcp-csv') in fluent_conf_content
        assert get_default_classify_conf('csv') in fluent_conf_content
        assert get_custom_classify_conf('tcp-csv') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('stdout') in fluent_conf_content
        assert is_valid_fluent_conf()


class TestCreateFluentConfChangingOutput:
    def test_create_conf_with_azure_loganalytics(self, monkeypatch):
        monkeypatch.setenv('AZURE_LOGANALYTICS_CUSTOMER_ID', 'AZURE_LOGANALYTICS_CUSTOMER_ID')
        monkeypatch.setenv('AZURE_LOGANALYTICS_SHARED_KEY', 'AZURE_LOGANALYTICS_SHARED_KEY')
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'tcp-json', 'azure-loganalytics')
        assert get_input_conf('tcp-json') in fluent_conf_content
        assert get_default_classify_conf('json') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('azure-loganalytics') in fluent_conf_content
        assert is_valid_fluent_conf()

    def test_create_conf_with_cloudwatch(self, monkeypatch):
        monkeypatch.setenv('AWS_ACCESS_KEY_ID', 'AWS_ACCESS_KEY_ID')
        monkeypatch.setenv('AWS_SECRET_ACCESS_KEY', 'AWS_SECRET_ACCESS_KEY')
        monkeypatch.setenv('AWS_REGION', 'AWS_REGION')
        monkeypatch.setenv('CLOUDWATCH_LOG_GROUP_NAME', 'CLOUDWATCH_LOG_GROUP_NAME')
        monkeypatch.setenv('CLOUDWATCH_LOG_STREAM_NAME', 'CLOUDWATCH_LOG_STREAM_NAME')
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'tcp-json', 'cloudwatch')
        assert get_input_conf('tcp-json') in fluent_conf_content
        assert get_default_classify_conf('json') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('cloudwatch') in fluent_conf_content
        assert is_valid_fluent_conf()

    def test_create_conf_with_datadog(self, monkeypatch):
        monkeypatch.setenv('HOSTNAME', 'HOSTNAME')
        monkeypatch.setenv('DATADOG_API_KEY', 'DATADOG_API_KEY')
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'tcp-json', 'datadog')
        assert get_input_conf('tcp-json') in fluent_conf_content
        assert get_default_classify_conf('json') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('datadog') in fluent_conf_content
        assert is_valid_fluent_conf()

    def test_create_conf_with_kafka(self, monkeypatch):
        monkeypatch.setenv('KAFKA_BROKERS', 'KAFKA_BROKERS')
        monkeypatch.setenv('KAFKA_TOPIC', 'KAFKA_TOPIC')
        monkeypatch.setenv('KAFKA_FORMAT_TYPE', 'json')
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'tcp-json', 'kafka')
        assert get_input_conf('tcp-json') in fluent_conf_content
        assert get_default_classify_conf('json') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('kafka') in fluent_conf_content
        assert is_valid_fluent_conf()

    def test_create_conf_with_s3(self, monkeypatch):
        monkeypatch.setenv('AWS_ACCESS_KEY_ID', 'AWS_ACCESS_KEY_ID')
        monkeypatch.setenv('AWS_SECRET_ACCESS_KEY', 'AWS_SECRET_ACCESS_KEY')
        monkeypatch.setenv('S3_BUCKET', 'S3_BUCKET')
        monkeypatch.setenv('S3_REGION', 'S3_REGION')
        monkeypatch.setenv('S3_PATH', 'S3_PATH')
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'tcp-json', 's3')
        assert get_input_conf('tcp-json') in fluent_conf_content
        assert get_default_classify_conf('json') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('s3') in fluent_conf_content
        assert is_valid_fluent_conf()

    def test_create_conf_with_splunk_hec(self, monkeypatch):
        monkeypatch.setenv('SPLUNK_HEC_HOST', 'SPLUNK_HEC_HOST')
        monkeypatch.setenv('SPLUNK_HEC_PORT', 'SPLUNK_HEC_PORT')
        monkeypatch.setenv('SPLUNK_HEC_TOKEN', 'SPLUNK_HEC_TOKEN')
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'tcp-json', 'splunk-hec')
        assert get_input_conf('tcp-json') in fluent_conf_content
        assert get_default_classify_conf('json') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('splunk-hec') in fluent_conf_content
        assert is_valid_fluent_conf()

    def test_create_conf_with_sumologic(self, monkeypatch):
        monkeypatch.setenv('SUMOLOGIC_ENDPOINT', 'https://endpoint.sumologic.com/token')
        monkeypatch.setenv('SUMOLOGIC_SOURCE_CATEGORY', 'SUMOLOGIC_SOURCE_CATEGORY')
        fluent_conf_content = generate_fluent_conf(monkeypatch, 'tcp-json', 'sumologic')
        assert get_input_conf('tcp-json') in fluent_conf_content
        assert get_default_classify_conf('json') in fluent_conf_content
        assert get_process_conf() in fluent_conf_content
        assert get_output_conf('sumologic') in fluent_conf_content
        assert is_valid_fluent_conf()


def generate_fluent_conf(monkeypatch, input_type, output_type):
    monkeypatch.setenv('LOG_EXPORT_CONTAINER_INPUT', input_type)
    monkeypatch.setenv('LOG_EXPORT_CONTAINER_OUTPUT', output_type)
    monkeypatch.setenv('FLUENTD_DIR', './fluentd')
    os.system("bash ./create-conf-file.sh")
    return read_file(f"{ETC_DIR}/fluent.conf")

def get_input_conf(input_type):
    return read_file(f"{ETC_DIR}/input-{input_type}.conf")

def get_default_classify_conf(classify_type):
    return read_file(f"{ETC_DIR}/classify-default-{classify_type}.conf")

def get_process_conf():
    return read_file(f"{ETC_DIR}/process.conf")

def get_output_conf(output_type):
    return read_file(f"{ETC_DIR}/output-{output_type}.conf")

def get_custom_classify_conf(input_type):
    return read_file(f"{ETC_DIR}/classify-{input_type}.conf")

def read_file(path):
    content = None
    with open(path) as file:
        content = file.read()
    return content

def is_valid_fluent_conf():
    return os.system(f"fluentd --dry-run -c {ETC_DIR}/fluent.conf -p ./fluentd/plugins") == 0
