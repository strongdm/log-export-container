# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('..', __dir__))
require 'test-unit'
require 'fluent/test'
require 'fluent/test/driver/output'
require 'fluent/test/helpers'
Test::Unit::TestCase.include(Fluent::Test::Helpers)
Test::Unit::TestCase.extend(Fluent::Test::Helpers)

module TestHelperModule
  def sample_chunk_log
    {
      'type' => 'chunk',
      'timestamp' => '2021-11-17T18:22:54.558133946Z',
      'uuid' => 's213cmKpvn5xRKQ3xSWcFRzBjTFh',
      'chunkId' => 1,
      'events' => [
        {
          'duration' => 186,
          'data' => 'V2VsY29tZSB0byBVYnVudHUgMjAuMDQuMiBMVFMgKEdOVS9MaW51eCA1LjExLjAtMTAyMC1hd3MgeDg2XzY0KQ0KDQogKiBEb2N1bWVudGF0aW9uOiAgaHR0cHM6Ly9oZWxwLnVidW50dS5jb20NCiAqIE1hbmFnZW1lbnQ6ICAgICBodHRwczovL2xhbmRzY2FwZS5jYW5vbmljYWwuY29tDQogKiBTdXBwb3J0OiAgICAgICAgaHR0cHM6Ly91YnVudHUuY29tL2FkdmFudGFnZQ0KDQogIFN5c3RlbSBpbmZvcm1hdGlvbiBhcyBvZiBXZWQgTm92IDE3IDE4OjIyOjQ3IFVUQyAyMDIxDQoNCiAgU3lzdGVtIGxvYWQ6ICAwLjAgICAgICAgICAgICAgICBQcm9jZXNzZXM6ICAgICAgICAgICAgICAgIDEyMg0KICBVc2FnZSBvZiAvOiAgIDMuNiUgb2YgOTYuODhHQiAgIFVzZXJzIGxvZ2dlZCBpbjogICAgICAgICAgMA0KICBNZW1vcnkgdXNhZ2U6IDIyJSAgICAgICAgICAgICAgIElQdjQgYWRkcmVzcyBmb3IgZG9ja2VyMDogMTcyLjE3LjAuMQ0KICBTd2FwIHVzYWdlOiAgIDAlICAgICAgICAgICAgICAgIElQdjQgYWRkcmVzcyBmb3IgZXRoMDogICAgMTcyLjMxLjcuMTY3DQoNCiAqIFVidW50dSBQcm8gZGVsaXZlcnMgdGhlIG1vc3QgY29tcHJlaGVuc2l2ZSBvcGVuIHNvdXJjZSBzZWN1cml0eSBhbmQNCiAgIGNvbXBsaWFuY2UgZmVhdHVyZXMuDQoNCiAgIGh0dHBzOi8vdWJ1bnR1LmNvbS9hd3MvcHJvDQoNCjgzIHVwZGF0ZXMgY2FuIGJlIGFwcGxpZWQgaW1tZWRpYXRlbHkuDQoxIG9mIHRoZXNlIHVwZGF0ZXMgaXMgYSBzdGFuZGFyZCBzZWN1cml0eSB1cGRhdGUuDQpUbyBzZWUgdGhlc2UgYWRkaXRpb25hbCB1cGRhdGVzIHJ1bjogYXB0IGxpc3QgLS11cGdyYWRhYmxlDQoNCg0KKioqIFN5c3RlbSByZXN0YXJ0IHJlcXVpcmVkICoqKg0KTGFzdCBsb2dpbjogV2VkIE5vdiAxNyAxODoyMjozMyAyMDIxIGZyb20gMzQuMjEyLjIyOC44DQ0K'
        },
        {
          'duration' => 35,
          'data' => 'G10wO3VidW50dUBpcC0xNzItMzEtNy0xNjc6IH4HG1swMTszMm11YnVudHVAaXAtMTcyLTMxLTctMTY3G1swMG06G1swMTszNG1+G1swMG0kIA=='
        },
        {
          'duration' => 600,
          'data' => 'cA=='
        },
        {
          'duration' => 159,
          'data' => 'dw=='
        },
        {
          'duration' => 36,
          'data' => 'ZA=='
        },
        {
          'duration' => 138,
          'data' => 'DQovaG9tZS91YnVudHUNChtdMDt1YnVudHVAaXAtMTcyLTMxLTctMTY3OiB+BxtbMDE7MzJtdWJ1bnR1QGlwLTE3Mi0zMS03LTE2NxtbMDBtOhtbMDE7MzRtfhtbMDBtJCA='
        },
        {
          'duration' => 781,
          'data' => 'bA=='
        },
        {
          'duration' => 96,
          'data' => 'cw=='
        },
        {
          'duration' => 65,
          'data' => 'IA=='
        },
        {
          'duration' => 88,
          'data' => 'LQ=='
        },
        {
          'duration' => 53,
          'data' => 'bA=='
        },
        {
          'duration' => 266,
          'data' => 'DQp0b3RhbCAxNDE2MA0KZHJ3eHJ3eHIteCAzIHVidW50dSB1YnVudHUgICAgIDQwOTYgT2N0IDI5IDE0OjM3IBtbMG0bWzAxOzM0bWdpdGh1YhtbMG0NCi1ydy1ydy1yLS0gMSB1YnVudHUgdWJ1bnR1IDE0NDkyNTkzIE9jdCAyMCAxODowNSAbWzAxOzMxbXNkbWNsaV8zMS4zNy4wX2xpbnV4X2FtZDY0LnppcBtbMG0NCg=='
        },
        {
          'duration' => 0,
          'data' => 'G10wO3VidW50dUBpcC0xNzItMzEtNy0xNjc6IH4HG1swMTszMm11YnVudHVAaXAtMTcyLTMxLTctMTY3G1swMG06G1swMTszNG1+G1swMG0kIA=='
        },
        {
          'duration' => 981,
          'data' => 'Yw=='
        },
        {
          'duration' => 81,
          'data' => 'bA=='
        },
        {
          'duration' => 93,
          'data' => 'ZQ=='
        },
        {
          'duration' => 64,
          'data' => 'YQ=='
        },
        {
          'duration' => 105,
          'data' => 'cg=='
        },
        {
          'duration' => 280,
          'data' => 'DQobW0gbWzJKG1szShtdMDt1YnVudHVAaXAtMTcyLTMxLTctMTY3OiB+BxtbMDE7MzJtdWJ1bnR1QGlwLTE3Mi0zMS03LTE2NxtbMDBtOhtbMDE7MzRtfhtbMDBtJCA='
        },
        {
          'duration' => 1150,
          'data' => 'ZQ=='
        },
        {
          'duration' => 190,
          'data' => 'eA=='
        },
        {
          'duration' => 56,
          'data' => 'aQ=='
        },
        {
          'duration' => 124,
          'data' => 'dA=='
        },
        {
          'duration' => 118,
          'data' => 'DQpsb2dvdXQNCg=='
        }
      ],
      'hash' => 'a068688cc2ccaaa4409d4a9d3c8551781073c60c',
      'sourceAddress' => '172.20.0.1',
      'sourceHostname' => 'cosmos.local'
    }
  end

  def sample_start_log
    {
      'type' => 'start',
      'timestamp' => '2021-11-17T17:21:39.351673907Z',
      'uuid' => 's213cmKpvn5xRKQ3xSWcFRzBjTFh',
      'datasourceId' => 'rs-249c99ea618e699f',
      'datasourceName' => 'Quimbik Gateway',
      'userId' => 'a-07a0dcc96140a424',
      'userName' => 'Rony Neves',
      'query' => "{\"version\":1,\"width\":80,\"height\":24,\"duration\":0,\"command\":\"\",\"title\":null,\"env\":{\"TERM\":\"xterm\"},\"type\":\"\",\"fileName\":null,\"fileSize\":0,\"stdout\":null,\"lastChunkId\":0,\"clientCommand\":null,\"pod\":null,\"container\":null,\"requestMethod\":\"\",\"requestURI\":\"\",\"requestBody\":null}\n",
      'hash' => '1a300f2e5978e97ac7a93cf3cba221ad650541a7',
      'sourceAddress' => '172.20.0.1',
      'sourceHostname' => 'cosmos.local'
    }
  end

  def sample_complete_log
    {
      'type' => 'complete',
      'timestamp' => '2021-11-17T17:21:50.739985029Z',
      'uuid' => 's213cmKpvn5xRKQ3xSWcFRzBjTFh',
      'duration' => 11_388,
      'records' => 0,
      'sourceAddress' => '172.20.0.1',
      'sourceHostname' => 'cosmos.local'
    }
  end
end
