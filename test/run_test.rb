# frozen_string_literal: true

base_dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))
test_dir = File.join(base_dir, 'test')

require 'test/unit'

exit Test::Unit::AutoRunner.run(true, test_dir)
