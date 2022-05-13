
require 'test/unit'
require 'fluent/test'
require 'fluent/test/helpers'
require_relative '../../fluentd/scripts/dump_utils'
require_relative '../stdout_utils'

FILE_PATH = "#{`pwd`.chomp}/sdm-audit-test-errors.log"

class TestBackoffRetry < Test::Unit::TestCase
  def cleanup
    super
    if File.exist?(FILE_PATH)
      File.delete(FILE_PATH)
    end
  end

  def teardown
    super
    if File.exist?(FILE_PATH)
      File.delete(FILE_PATH)
    end
  end

  def test_when_run_successfully
    calls_count = 0
    result = nil
    omit_stdout do
      result = backoff_retry(-> () {
        calls_count += 1
        mock_success
      }, "test", FILE_PATH)
    end
    assert_true(result)
    assert_true(File.exist?(FILE_PATH))
    assert_empty(File.read(FILE_PATH))
    assert_equal(1, calls_count)
  end

  def test_when_fails_and_dont_exceed_retry
    calls_count = 0
    result = nil
    omit_stdout do
      result = backoff_retry(-> () {
        calls_count += 1
        mock_fail_once
      }, "test", FILE_PATH)
    end
    assert_true(result)
    assert_true(File.exist?(FILE_PATH))
    assert_empty(File.read(FILE_PATH))
    assert_equal(2, calls_count)
  end

  def test_when_exceed_retry
    calls_count = 0
    result = nil
    omit_stdout do
      result = backoff_retry(-> () {
        calls_count += 1
        mock_fail
      }, "test", FILE_PATH)
    end
    assert_nil(result)
    assert_true(File.exist?(FILE_PATH))
    assert_not_empty(File.read(FILE_PATH))
    assert_equal(4, calls_count)
  end

  private
  def mock_success
    File.new(FILE_PATH, "w+")
    true
  end

  def mock_fail_once
    if File.exist?(FILE_PATH)
      mock_success
    else
      mock_fail
      nil
    end
  end

  def mock_fail
    File.write(FILE_PATH, "w") do |file|
      file.write("error")
    end
    nil
  end
end
