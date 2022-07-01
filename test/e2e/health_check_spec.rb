require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/test/driver/output'
require 'uri'
require 'net/http'
require 'json'
require_relative '../common'
require_relative '../helper'

SIGTERM = 15

describe 'health_check' do
  fluent_thread = nil

  before(:each) do
    ENV['MONGO_URI'] = 'mongodb://host'
    generate_fluent_conf('syslog-json', 'stdout mongo')
    _, stdout, _, fluent_thread = Open3.popen3("fluentd -c #{ETC_DIR}/fluent.conf -p ./fluentd/plugins")
    wait_for_fluent(stdout)
    clear_buffer(stdout)
  end

  after(:each) do
    Process.kill(SIGTERM, fluent_thread&.pid)
  end

  it "should return all inputs and outputs status" do
    uri = URI('http://localhost:24220/api/health-check')
    res = Net::HTTP.get_response(uri)

    expect(res.is_a?(Net::HTTPSuccess))
    health_data = JSON.parse(res.body)
    inputs_types = health_data["inputs"].map { |plugin| plugin["type"] }
    outputs_types = health_data["outputs"].map { |plugin| plugin["type"] }
    expect(inputs_types).to include("syslog")
    expect(outputs_types).to include("stdout")
    expect(outputs_types).to include("mongo")
  end
end
