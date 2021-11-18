# frozen_string_literal: true

require 'rspec/mocks'
require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/output'
require_relative '../helper'
require_relative '../../fluentd/plugins/filter_sdm_decode_chunk_events'

class TestSDMDecodeChunkEventsFilter < Test::Unit::TestCase
  include Fluent::Test::Helpers
  include TestHelperModule

  def setup
    Fluent::Test.setup
    create_filter

    @env_backup = {
      'LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS' => ENV['LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS']
    }

    ENV['LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS'] = 'true'
  end

  def cleanup
    ENV['LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS'] = @env_backup['LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS']
  end

  def create_filter
    @filter = Fluent::Plugin::SDMDecodeChunkEventsFilter.new
    @filter.configure(Fluent::Config::Element.new('ROOT', '', {}, []))
  end

  def test_success_when_correct_logs
    expected_decoded_event = sample_decoded_chunk_log['decodedEvents'][0]
    filtered_chunk = @filter.filter(nil, nil, sample_chunk_log)
    assert_not_empty(filtered_chunk['decodedEvents'])
    decoded_event = filtered_chunk['decodedEvents'][0]
    assert_equal(expected_decoded_event['startTimestamp'], decoded_event['startTimestamp'])
    assert_equal(expected_decoded_event['endTimestamp'], decoded_event['endTimestamp'])
    assert_equal(expected_decoded_event['data']&.length, decoded_event['data']&.length)
    assert_equal(expected_decoded_event['data'][0], decoded_event['data'][0])
  end

  def test_when_disabled
    ENV['LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS'] = 'false'

    chunk_log = sample_chunk_log
    filtered_chunk = @filter.filter(nil, nil, chunk_log)
    assert_nil(filtered_chunk['decodedEvents'])
  end

  def test_when_no_events
    chunk_log = sample_chunk_log
    chunk_log.delete('events')
    filtered_chunk = @filter.filter(nil, nil, chunk_log)
    assert_nil(filtered_chunk['decodedEvents'])
  end

  def test_when_no_event_data
    chunk_log = sample_chunk_log
    chunk_log['events'][0]&.delete('data')
    filtered_chunk = @filter.filter(nil, nil, chunk_log)
    assert_nil(filtered_chunk['decodedEvents'])
  end
end
