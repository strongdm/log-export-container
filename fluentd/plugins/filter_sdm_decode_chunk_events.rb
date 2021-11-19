# frozen_string_literal: true

require 'fluent/plugin/parser'
require 'fluent/plugin/parser_json'

module Fluent::Plugin
  class SDMDecodeChunkEventsFilter < Filter
    Fluent::Plugin.register_filter('sdm_decode_chunk_events', self)

    def filter(tag, time, record)
      if ENV['LOG_EXPORT_CONTAINER_DECODE_CHUNK_EVENTS']&.downcase == 'true'
        decode_chunk_log(record)
      else
        record
      end
    end

    private

    def decode_chunk_log(record)
      decoded_events = []

      full_cmd_entry = ''
      total_elapsed_millis = 0
      start_time_regular = zulu_date_to_regular(record['timestamp'])
      begin
        record['events'].each do |event|
          duration, command = extract_cmd_entry_info(event)
          one_line_cmd_entry = command.gsub("\r", '')
          total_elapsed_millis += duration
          full_cmd_entry = "#{full_cmd_entry}#{one_line_cmd_entry}"

          next unless end_of_line(one_line_cmd_entry)

          end_time_regular = add_millis(start_time_regular, total_elapsed_millis)

          item = {
            'data' => full_cmd_entry.split("\n"),
            'startTimestamp' => start_time_regular,
            'endTimestamp' => end_time_regular
          }

          decoded_events << item

          full_cmd_entry = ''
          total_elapsed_millis = 0
          start_time_regular = end_time_regular
        end

        record['decodedEvents'] = decoded_events unless record['decodedEvents']
      rescue StandardError => _e
        # Ignored
      end

      record
    end

    def end_of_line(line)
      line.include? "\n"
    end

    def zulu_date_to_regular(input_date)
      input_date.gsub(/[0-9]{,3} \+[0-9]{,4} UTC$/, '')
    end

    def extract_cmd_entry_info(line)
      [line['duration'], Base64.decode64(line['data']).force_encoding('utf-8')]
    end

    def add_millis(input_date, input_millis)
      new_date = Time.parse input_date
      (new_date.to_time + input_millis / 1000.0).iso8601(3).to_s
    end
  end
end
