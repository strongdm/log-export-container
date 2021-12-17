# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('..', __dir__))
require 'json'
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
      'hash' => '8964394d39ccb9667a0642e176bac17000000000'
    }
  end
end
