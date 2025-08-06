#!/usr/bin/env ruby

# Load the application configuration
require_relative 'lib/config/application'

# Initialize the application
DiscountingApp::Application.initialize!

# Start the application if this file is being run directly
if __FILE__ == $PROGRAM_NAME
  # Your application startup code here
  puts "Welcome to DiscountingApp!"

  
end 