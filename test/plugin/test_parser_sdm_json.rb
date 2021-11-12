# frozen_string_literal: true

require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/output'
require_relative '../../fluentd/plugins/parser_sdm_json'

class TestParserSDMJSON < Test::Unit::TestCase
  include Fluent::Test::Helpers

  def setup
    Fluent::Test.setup
    create_driver
    @expected_json = {
      'type' => 'complete',
      'timestamp' => '2021-06-22T17:15:19.758785454Z',
      'uuid' => '01uJSIaxJKEf6y85VRAoypiPJUGJ',
      'duration' => 0,
      'records' => 1
    }
    @incomplete_json = '{"type":'
    @correct_log = "2021-06-22T17:15:19Z ip-172-31-3-25 strongDM[734548]: #{@expected_json.to_json}"
  end

  def create_driver
    @parser = Fluent::Plugin::SDMJsonParser.new
    @parser.configure(Fluent::Config::Element.new('ROOT', '', {}, []))
  end

  def test_success_when_correct_json
    @parser.parse(@correct_log) do |_, record|
      assert_instance_of(Hash, record)
      assert_equal(record['type'], @expected_json['type'])
      assert_equal(record['timestamp'], @expected_json['timestamp'])
      assert_equal(record['uuid'], @expected_json['uuid'])
      assert_equal(record['duration'], @expected_json['duration'])
      assert_equal(record['records'], @expected_json['records'])
    end
  end

  def test_fail_when_empty_log
    @parser.parse('') do |_, record|
      assert_nil(record)
    end
  end

  def test_fail_when_incomplete_json
    @parser.parse(@incomplete_json) do |_, record|
      assert_not_instance_of(Hash, record)
    end
  end
end
