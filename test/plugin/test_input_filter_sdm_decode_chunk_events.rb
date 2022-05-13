# frozen_string_literal: true

require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require_relative '../helper'
require_relative '../stdout_utils'
require_relative '../../fluentd/plugins/filter_sdm_decode_chunk_events'

class TestSDMDecodeChunkEventsFilter < Test::Unit::TestCase
  include Fluent::Test::Helpers
  include TestHelperModule

  def setup
    Fluent::Test.setup
    create_filter
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

  def test_when_no_events
    chunk_log = sample_chunk_log
    chunk_log.delete('events')
    filtered_chunk = nil
    omit_stdout do
      filtered_chunk = @filter.filter(nil, nil, chunk_log)
    end
    assert_nil(filtered_chunk['decodedEvents'])
  end

  def test_when_no_event_data
    chunk_log = sample_chunk_log
    chunk_log['events'][0]&.delete('data')
    filtered_chunk = nil
    omit_stdout do
      filtered_chunk = @filter.filter(nil, nil, chunk_log)
    end
    assert_nil(filtered_chunk['decodedEvents'])
  end
end

def sample_decoded_chunk_log
  {
    'type' => 'chunk',
    'timestamp' => '2021-11-18T18:36:50.186372557Z',
    'uuid' => 'xxx',
    'chunkId' => 1,
    'events' => [
      {
        'duration' => 180,
        'data' => 'V2VsY29tZSB0byBVYnVudHUgMjAuMDQuMiBMVFMgKEdOVS9MaW51eCA1LjExLjAtMTAyMC1hd3MgeDg2XzY0KQ0KDQogKiBEb2N1bWVudGF0aW9uOiAgaHR0cHM6Ly9oZWxwLnVidW50dS5jb20NCiAqIE1hbmFnZW1lbnQ6ICAgICBodHRwczovL2xhbmRzY2FwZS5jYW5vbmljYWwuY29tDQogKiBTdXBwb3J0OiAgICAgICAgaHR0cHM6Ly91YnVudHUuY29tL2FkdmFudGFnZQ0KDQogIFN5c3RlbSBpbmZvcm1hdGlvbiBhcyBvZiBUaHUgTm92IDE4IDE4OjM2OjQ1IFVUQyAyMDIxDQoNCiAgU3lzdGVtIGxvYWQ6ICAwLjAxICAgICAgICAgICAgICBQcm9jZXNzZXM6ICAgICAgICAgICAgICAgIDEyMA0KICBVc2FnZSBvZiAvOiAgIDMuOCUgb2YgOTYuODhHQiAgIFVzZXJzIGxvZ2dlZCBpbjogICAgICAgICAgMA0KICBNZW1vcnkgdXNhZ2U6IDIzJSAgICAgICAgICAgICAgIElQdjQgYWRkcmVzcyBmb3IgZG9ja2VyMDogMTcyLjE3LjAuMQ0KICBTd2FwIHVzYWdlOiAgIDAlICAgICAgICAgICAgICAgIElQdjQgYWRkcmVzcyBmb3IgZXRoMDogICAgMTcyLjMxLjcuMTY3DQoNCg0KOTAgdXBkYXRlcyBjYW4gYmUgYXBwbGllZCBpbW1lZGlhdGVseS4NCjEgb2YgdGhlc2UgdXBkYXRlcyBpcyBhIHN0YW5kYXJkIHNlY3VyaXR5IHVwZGF0ZS4NClRvIHNlZSB0aGVzZSBhZGRpdGlvbmFsIHVwZGF0ZXMgcnVuOiBhcHQgbGlzdCAtLXVwZ3JhZGFibGUNCg0KDQoqKiogU3lzdGVtIHJlc3RhcnQgcmVxdWlyZWQgKioqDQpMYXN0IGxvZ2luOiBUaHUgTm92IDE4IDE4OjM2OjEwIDIwMjEgZnJvbSAzNC4yMTIuMjI4LjgNDQo='
      },
      {
        'duration' => 36,
        'data' => 'G10wO3VidW50dUBpcC0xNzItMzEtNy0xNjc6IH4HG1swMTszMm11YnVudHVAaXAtMTcyLTMxLTctMTY3G1swMG06G1swMTszNG1+G1swMG0kIA=='
      },
      {
        'duration' => 1937,
        'data' => 'bA=='
      },
      {
        'duration' => 70,
        'data' => 'cw=='
      },
      {
        'duration' => 37,
        'data' => 'IA=='
      },
      {
        'duration' => 72,
        'data' => 'LQ=='
      },
      {
        'duration' => 44,
        'data' => 'bA=='
      },
      {
        'duration' => 252,
        'data' => 'DQp0b3RhbCAxNDE2MA0KZHJ3eHJ3eHIteCAzIHVidW50dSB1YnVudHUgICAgIDQwOTYgT2N0IDI5IDE0OjM3IBtbMG0bWzAxOzM0bWdpdGh1YhtbMG0NCi1ydy1ydy1yLS0gMSB1YnVudHUgdWJ1bnR1IDE0NDkyNTkzIE9jdCAyMCAxODowNSAbWzAxOzMxbXNkbWNsaV8zMS4zNy4wX2xpbnV4X2FtZDY0LnppcBtbMG0NChtdMDt1YnVudHVAaXAtMTcyLTMxLTctMTY3OiB+BxtbMDE7MzJtdWJ1bnR1QGlwLTE3Mi0zMS03LTE2NxtbMDBtOhtbMDE7MzRtfhtbMDBtJCA='
      },
      {
        'duration' => 266,
        'data' => 'ZQ=='
      },
      {
        'duration' => 145,
        'data' => 'eA=='
      },
      {
        'duration' => 72,
        'data' => 'aQ=='
      },
      {
        'duration' => 101,
        'data' => 'dA=='
      },
      {
        'duration' => 74,
        'data' => 'DQpsb2dvdXQNCg=='
      }
    ],
    'hash' => '8964394d39ccb9667a0642e176bac17000000000',
    'sourceAddress' => '0.0.0.0',
    'sourceHostname' => 'localhost',
    'decodedEvents' => [
      {
        'data' => [
          'Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.11.0-1020-aws x86_64)',
          '',
          ' * Documentation:  https://help.ubuntu.com',
          ' * Management:     https://landscape.canonical.com',
          ' * Support:        https://ubuntu.com/advantage',
          '',
          '  System information as of Thu Nov 18 18:36:45 UTC 2021',
          '',
          '  System load:  0.01              Processes:                120',
          '  Usage of /:   3.8% of 96.88GB   Users logged in:          0',
          '  Memory usage: 23%               IPv4 address for docker0: 172.17.0.1',
          '  Swap usage:   0%                IPv4 address for eth0:    172.31.7.167',
          '',
          '',
          '90 updates can be applied immediately.',
          '1 of these updates is a standard security update.',
          'To see these additional updates run: apt list --upgradable',
          '',
          '',
          '*** System restart required ***',
          'Last login: Thu Nov 18 18:36:10 2021 from 34.212.228.8'
        ],
        'startTimestamp' => '2021-11-18T18:36:50.186372557Z',
        'endTimestamp' => '2021-11-18T18:36:50.366Z'
      },
      {
        'data' => [
          "\u001b]0;ubuntu@ip-172-31-7-167: ~\u0007\u001b[01;32mubuntu@ip-172-31-7-167\u001b[00m:\u001b[01;34m~\u001b[00m$ ls -l",
          'total 14160',
          "drwxrwxr-x 3 ubuntu ubuntu     4096 Oct 29 14:37 \u001b[0m\u001b[01;34mgithub\u001b[0m",
          "-rw-rw-r-- 1 ubuntu ubuntu 14492593 Oct 20 18:05 \u001b[01;31msdmcli_31.37.0_linux_amd64.zip\u001b[0m",
          "\u001b]0;ubuntu@ip-172-31-7-167: ~\u0007\u001b[01;32mubuntu@ip-172-31-7-167\u001b[00m:\u001b[01;34m~\u001b[00m$ "
        ],
        'startTimestamp' => '2021-11-18T18:36:50.366Z',
        'endTimestamp' => '2021-11-18T18:36:52.813Z'
      },
      {
        'data' => %w[
            exit
            logout
          ],
        'startTimestamp' => '2021-11-18T18:36:52.813Z',
        'endTimestamp' => '2021-11-18T18:36:53.471Z'
      }
    ]
  }
end
