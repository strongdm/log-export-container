# frozen_string_literal: true

require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/output'
require_relative '../../fluentd/plugins/parser_sdm_json'

class TestSDMJsonParser < Test::Unit::TestCase
  include Fluent::Test::Helpers

  def setup
    Fluent::Test.setup
    create_parser
  end

  def create_parser
    @parser = Fluent::Plugin::SDMJsonParser.new
    @parser.configure(Fluent::Config::Element.new('ROOT', '', {}, []))
  end

  def test_success_when_correct_json
    expected_json = {
      'type' => 'start',
      'timestamp' => '2021-11-12T14:25:24.648855724Z',
      'uuid' => '020p2I2F1MNqowg7f33KWAOoxxxx',
      'datasourceId' => 'rs-yyyyyyyy',
      'datasourceName' => 'simple-website',
      'userId' => 'a-xxxxxxxx',
      'userName' => 'A User',
      'query' => "GET / HTTP/1.1\r\nHost: simple-website.website-test-org.sdm.network\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9\r\nAccept-Encoding: gzip, deflate\r\nAccept-Language: en-US,en;q=0.9\r\nCache-Control: max-age=0\r\nIf-Modified-Since: Tue, 07 Sep 2021 15:21:03 GMT\r\nIf-None-Match: \"6137835f-267\"\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36\r\nX-Forwarded-For: 127.0.0.1\r\n\r\n",
      'hash' => '1bd7bdff0e9868059feec0b066742d13db97a7e3',
      'sourceAddress' => '172.17.0.1',
      'sourceHostname' => '172.17.0.1'
    }
    full_log = "2021-11-12T14:25:24Z ip-172-31-3-25 strongDM[734548]: #{expected_json.to_json}"
    @parser.parse(full_log) do |_, record|
      assert_instance_of(Hash, record)
      assert_equal(record['type'], expected_json['type'])
      assert_equal(record['timestamp'], expected_json['timestamp'])
      assert_equal(record['uuid'], expected_json['uuid'])
      assert_equal(record['duration'], expected_json['duration'])
      assert_equal(record['records'], expected_json['records'])
    end
  end

  def test_fail_when_empty_log
    @parser.parse('') do |_, record|
      assert_nil(record)
    end
  end

  def test_fail_when_invalid_log_format
    @parser.parse('invalid') do |_, record|
      assert_nil(record)
    end
  end

  def test_fail_when_incomplete_json
    @parser.parse('{"type":') do |_, record|
      assert_not_instance_of(Hash, record)
    end
  end
end
