# frozen_string_literal: true

require 'fluent/plugin/in_monitor_agent'

module Fluent::Plugin
  class SDMHealthCheckInput < MonitorAgentInput
    Fluent::Plugin.register_input('sdm_health_check', self)

    def start
      api_handler = APIHandler.new(self)
      log.debug "listening monitoring http server on http://#{@bind}:#{@port}/api/health-check for worker#{fluentd_worker_id}"
      http_server_create_http_server(:in_monitor_http_server_helper, addr: @bind, port: @port, logger: log, default_app: NotFoundJson) do |serv|
        serv.get('/api/health-check') { |req| health_json(req) }
      end
    end

    def health_json(req)
      begin
        render_json(
          {
            "timestamp" => DateTime.now,
            "uptime_seconds" => uptime_seconds,
            "inputs" => input_plugins_health_data(req),
            "outputs" => output_plugins_health_data(req),
          },
          pretty_json: true
        )
      rescue Exception => e
        puts e
      end
    end

    def uptime_seconds
      ps_output = `ps -o etime,args | grep "fluentd -c"`
      fluentd_info = ps_output.split("\n")[0]
      elapsed_time_str = fluentd_info.match(/[0-9]+(:[0-9]+)+/)
      elapsed_time_parts = elapsed_time_str.to_s.split(":")
      elapsed_seconds = 0
      time_unit_multiplier = 1
      for i in 0..(elapsed_time_parts.length - 1) do
        elapsed_seconds += elapsed_time_parts[elapsed_time_parts.length - 1 - i].to_i * time_unit_multiplier
        print ">" + elapsed_seconds.to_s
        time_unit_multiplier *= i >= 2 ? 24 : 60
      end
      elapsed_seconds
    end

    def input_plugins_health_data(req)
      api_handler = APIHandler.new(self)
      plugins_json = api_handler.plugins_json(req)
      plugins_obj = JSON.parse(plugins_json[2])

      health_data = []
      plugins_obj["plugins"]&.each { |plugin|
        if plugin["plugin_category"] != 'input'
          next
        end

        plugin_health_data = {
          "type" => plugin["type"],
          "category" => plugin["plugin_category"],
        }

        if plugin["config"]["tag"] != nil
          plugin_health_data["tag"] = plugin["config"]["tag"]
        end

        health_data << plugin_health_data
      }
      health_data
    end

    def output_plugins_health_data(req)
      api_handler = APIHandler.new(self)
      plugins_json = api_handler.plugins_json(req)
      plugins_obj = JSON.parse(plugins_json[2])

      health_data = []
      plugins_obj["plugins"]&.each { |plugin|
        if plugin["plugin_category"] != 'output'
          next
        end

        plugin_health_data = {
          "type" => plugin["type"],
          "category" => plugin["plugin_category"],
          "alive" => plugin["retry"] == nil || plugin["retry"].keys.length == 0
        }

        health_data << plugin_health_data
      }
      health_data
    end

    def render_json(obj, code: 200, pretty_json: nil)
      body =
        if pretty_json
          JSON.pretty_generate(obj)
        else
          obj.to_json
        end

      [code, { 'Content-Type' => 'application/json' }, body]
    end
  end
end
