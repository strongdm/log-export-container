# frozen_string_literal: true

require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/output'
require_relative '../helper'
require_relative '../../fluentd/plugins/filter_sdm_ssh_events'

class TestSDMSSHEventsFilter < Test::Unit::TestCase
  include Fluent::Test::Helpers
  include TestHelperModule

  def setup
    Fluent::Test.setup
    create_filter
  end

  def create_filter
    @filter = Fluent::Plugin::SDMSSHEventsFilter.new
    @filter.configure(Fluent::Config::Element.new('ROOT', '', {}, []))
  end

  def test_success_when_correct_logs
    expected_start_log = sample_start_log
    expected_chunk_log = sample_chunk_log
    expected_complete_log = sample_complete_log

    @filter.filter(nil, nil, expected_start_log)
    filtered_chunk = @filter.filter(nil, nil, expected_chunk_log)
    @filter.filter(nil, nil, expected_complete_log)

    assert_equal(expected_start_log['userId'], filtered_chunk['userId'])
    assert_equal(expected_start_log['userName'], filtered_chunk['userName'])
    assert_equal(expected_start_log['datasourceName'], filtered_chunk['datasourceName'])
    assert_equal(expected_start_log['datasourceId'], filtered_chunk['datasourceId'])
    assert_not_empty(filtered_chunk['rawOutput'])
  end
end
