# frozen_string_literal: true

require 'fluent/plugin/parser'
require 'fluent/plugin/parser_json'

module Fluent::Plugin
  class SDMSSHEventsFilter < Filter
    Fluent::Plugin.register_filter('sdm_ssh_events', self)

    def configure(conf)
      super

      @_start_log_hash = {}
    end

    def filter(tag, time, record)
      handle_start_log(record) if record['type'] == 'start'
      record = handle_chunk_log(record) if record['type'] == 'chunk'
      handle_complete_log(record) if record['type'] == 'complete'
      record
    end

    private

    def handle_start_log(start_record)
      @_start_log_hash[start_record['uuid']] = start_record
    end

    def handle_complete_log(start_record)
      @_start_log_hash.delete(start_record['uuid'])
    end

    def decode_chunk_log(record)
      decoded_events = []

      full_cmd_entry = ''
      total_elapsed_millis = 0
      start_time_regular = zulu_date_to_regular(record['timestamp'])
      record['events'].each do |event|
        duration, command = extract_cmd_entry_info(event)
        one_line_cmd_entry = command.gsub("\r", '')
        total_elapsed_millis += duration
        full_cmd_entry = "#{full_cmd_entry}#{one_line_cmd_entry}"

          next unless end_of_line(one_line_cmd_entry)

          end_time_regular = add_millis(start_time_regular, total_elapsed_millis)

        item = {
          'texts' => full_cmd_entry.split("\n"),
          'startTimestamp' => start_time_regular,
          'endTimestamp' => end_time_regular
        }

        record['rawOutput'] << item

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
