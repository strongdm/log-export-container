
require 'fluent/test/driver/output'

def omit_stdout
  original_stdout = $stdout
  $stdout = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
end
