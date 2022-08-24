
require 'open3'
require 'socket'
require_relative "../../fluentd/scripts/dump_sdm_entities"

describe 'dump_activities' do
  describe "stream_activities" do
    let(:wait_thr) { double }
    let(:wait_thr_value) { double }
    let(:stdout_and_stderr) { double }
    let(:socket) { double }

    before(:each) do
      ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'] = 'activities/stream'
      ENV['LOG_EXPORT_CONTAINER_INPUT'] = 'syslog-json'
      allow(wait_thr).to receive(:value).and_return(wait_thr_value)
      allow(wait_thr).to receive(:pid).and_return(nil)
      allow(wait_thr_value).to receive(:exitcode).and_return(0)
      allow(wait_thr_value).to receive(:success?).and_return(true)
      allow(stdout_and_stderr).to receive(:each).and_yield(activity_audit_log)
      allow(Open3).to receive(:popen2e).with('sdm audit activities -e -f -j').and_return([nil, stdout_and_stderr, wait_thr])
      allow(TCPSocket).to receive(:open).and_return(socket, nil)
      allow(socket).to receive(:puts)
      allow(socket).to receive(:close)
      allow(Process).to receive(:kill)
    end

    it "should stream activities when enabled" do
      dump_entities("activities")
      expect(Open3).to have_received(:popen2e).with('sdm audit activities -e -f -j')
      expect(stdout_and_stderr).to have_received(:each)
      expect(TCPSocket).to have_received(:open)
      expect(socket).to have_received(:puts).with("<5>#{JSON.generate(parse_entity(activity_audit_log, 'activities'))}")
      expect(socket).to have_received(:close)
    end

    after(:each) do
      ENV['LOG_EXPORT_CONTAINER_EXTRACT_AUDIT'] = nil
      ENV['LOG_EXPORT_CONTAINER_INPUT'] = nil
    end
  end

  # TODO add tests for extract activities by interval
end

def activity_audit_log
  '{"activity":"user logged into the local client","actorName":"User xxx (email@domain.com)","actorUserID":"a-xxx","description":"User xxx (email@domain.com) logged into the local client.","ip_address":"yyy.yyy.yyy.yyy","timestamp":"2022-06-16T13:40:40.284888Z","type":"activity","sourceAddress":"127.0.0.1","sourceHostname":"localhost"}' + "\n"
end
