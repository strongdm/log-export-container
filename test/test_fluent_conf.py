import os
import pytest

ETC_DIR = './fluentd/etc'

@pytest.fixture(autouse=True)
def run_around_tests():
    yield
    after_each()

def before_each(monkeypatch, input_type = 'syslog-json', output_type = 'stdout'):
    monkeypatch.setenv('LOG_EXPORT_CONTAINER_INPUT', input_type)
    monkeypatch.setenv('LOG_EXPORT_CONTAINER_OUTPUT', output_type)
    monkeypatch.setenv('FLUENTD_DIR', './fluentd')
    os.system("bash ./create_conf_file.sh")

def after_each():
    # Keep attention to running the test in the root dir of the project
    os.remove(f'{ETC_DIR}/fluent.conf')


# TODO: sometime we will need to validate the sequence of the fluentd.conf file.
class TestCreateFluentConfChangingInput:
    def test_create_syslog_json_conf(self, monkeypatch):
        before_each(monkeypatch, input_type = 'syslog-json')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_syslog_csv_conf(self, monkeypatch):
        before_each(monkeypatch, input_type = 'syslog-csv')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_tcp_json_conf(self, monkeypatch):
        before_each(monkeypatch, input_type = 'tcp-json')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_tcp_csv_conf(self, monkeypatch):
        before_each(monkeypatch, input_type = 'tcp-csv')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content


class TestCreateFluentConfChangingOutput:
    def test_create_conf_with_azure_loganalytics(self, monkeypatch):
        before_each(monkeypatch, output_type = 'azure-loganalytics')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_conf_with_cloudwatch(self, monkeypatch):
        before_each(monkeypatch, output_type = 'cloudwatch')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_conf_with_datadog(self, monkeypatch):
        before_each(monkeypatch, output_type = 'datadog')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_conf_with_kafka(self, monkeypatch):
        before_each(monkeypatch, output_type = 'kafka')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_conf_with_s3(self, monkeypatch):
        before_each(monkeypatch, output_type = 's3')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_conf_with_splunk_hec(self, monkeypatch):
        before_each(monkeypatch, output_type = 'splunk-hec')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_conf_with_stdout(self, monkeypatch):
        before_each(monkeypatch, output_type = 'stdout')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content

    def test_create_conf_with_sumologic(self, monkeypatch):
        before_each(monkeypatch, output_type = 'sumologic')

        input_content, classify_default_content, classify_custom_content, \
            process_content, output_content = conf_files()

        fluent_conf_content = read_file(f"{ETC_DIR}/fluent.conf")

        assert input_content in fluent_conf_content
        assert classify_default_content in fluent_conf_content
        assert classify_custom_content in fluent_conf_content
        assert process_content in fluent_conf_content
        assert output_content in fluent_conf_content




class TestValidateFluentdConfSyntax:
    def test_when_input_is_syslog_json(self, monkeypatch):
        before_each(monkeypatch, input_type = 'syslog-json')

        result = os.system(f"fluentd --dry-run -c {ETC_DIR}/fluent.conf -p ./fluentd/plugins")

        assert result == 0

    def test_when_input_is_syslog_csv(self, monkeypatch):
        before_each(monkeypatch, input_type = 'syslog-csv')

        result = os.system(f"fluentd --dry-run -c {ETC_DIR}/fluent.conf -p ./fluentd/plugins")

        assert result == 0

    def test_when_input_is_tcp_json(self, monkeypatch):
        before_each(monkeypatch, input_type = 'tcp-json')

        result = os.system(f"fluentd --dry-run -c {ETC_DIR}/fluent.conf -p ./fluentd/plugins")

        assert result == 0

    def test_when_input_is_tcp_csv(self, monkeypatch):
        before_each(monkeypatch, input_type = 'tcp-csv')

        result = os.system(f"fluentd --dry-run -c {ETC_DIR}/fluent.conf -p ./fluentd/plugins")

        assert result == 0


def read_file(path):
    content = None
    with open(path) as file:
        content = file.read()
    return content

def get_input_conf():
    input_type = os.getenv('LOG_EXPORT_CONTAINER_INPUT')
    content = read_file(f"{ETC_DIR}/input-{input_type}.conf")
    return content

def get_default_classify_conf():
    input_type = os.getenv('LOG_EXPORT_CONTAINER_INPUT')

    if 'csv' in input_type:
        classify_type = 'csv'
    else:
        classify_type = 'json'

    content = read_file(f"{ETC_DIR}/classify-default-{classify_type}.conf")

    return content

def get_process_conf():
    return read_file(f"{ETC_DIR}/process.conf")

def get_output_conf():
    output = os.getenv('LOG_EXPORT_CONTAINER_OUTPUT')

    return read_file(f"{ETC_DIR}/output-{output}.conf")

def get_custom_classify_conf():
    input_type = os.getenv('LOG_EXPORT_CONTAINER_INPUT')

    if 'csv' in input_type:
        return read_file(f"{ETC_DIR}/classify-{input_type}.conf")

    return ""

def conf_files():
    input_content = get_input_conf()
    classify_default_content = get_default_classify_conf()
    custom_classify_content = get_custom_classify_conf()
    process_content = get_process_conf()
    output_content = get_output_conf()

    return input_content, classify_default_content, \
        custom_classify_content, process_content, output_content
