#!/usr/bin/env ruby

require_relative 'config/environment'
require_relative 'data/test_runner'

# Start the application if this file is being run directly
if __FILE__ == $PROGRAM_NAME
  # Your application startup code here
  puts "Welcome to DiscountingApp!"

  DiscountingApp::TestRunner.run
end
