#!/usr/bin/env ruby

# Load the Rails environment
require File.expand_path('../config/environment', __FILE__)

# Start the application if this file is being run directly
if __FILE__ == $PROGRAM_NAME
  # Your application startup code here
  puts "Welcome to DiscountingApp!"

  # You can now use Rails models and services here
  # For example:
  # puts Product.count
  # puts CustomerProfile.first
end
