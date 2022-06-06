
require 'json'

DEFAULT_RETRY_INTERVAL = 2
BACKOFF_MAX_RETRIES = 3

def backoff_retry(exec_fn, entity, error_file_path)
  retries = 0
  begin
    result = exec_fn.()
    errors = ""
    if File.exist?(error_file_path)
      errors = File.read(error_file_path)
    end
    if errors != ""
      raise StandardError.new errors.chomp
    end
    result
  rescue StandardError => e
    if retries < BACKOFF_MAX_RETRIES
      puts "#{JSON.generate({"error_message" => "#{e.to_s} (retrying for the #{retries + 1} time)"})}"
      sleep DEFAULT_RETRY_INTERVAL ** retries
      retries += 1
      retry
    else
      puts "#{JSON.generate({"error_message" => "Aborting audit #{entity} extraction - the retrials count was exceeded"})}"
    end
  end
end
