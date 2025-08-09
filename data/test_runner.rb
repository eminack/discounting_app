#!/usr/bin/env ruby

require_relative '../config/environment'
require_relative 'test_cases'

module DiscountingApp
  class TestRunner
    def self.run
      puts "\nRunning Discount Test Cases"
      puts "==========================\n\n"

      test_cases = TestCases::DiscountTestCases.get_test_cases
      
      test_cases.each_with_index do |test_case, index|
        puts "Test Case #{index + 1}: #{test_case[:name]}"
        puts "----------------------------------------"

        # Create context from test case
        context = Context.new(
          cart: Cart.new(cart_items: test_case[:cart_items]),
          customer: test_case[:customer],
          payment_info: test_case[:payment_info]
        )

        # Create discount service with test case specific discounts
        discount_service = DiscountService.new(test_case[:discounts])

        # Calculate discounts
        result = discount_service.calculate_cart_discounts(context)

        # Print cart items
        puts "\nCart Items:"
        context.cart.cart_items.each do |item|
          puts "#{item.product.brand} #{item.product.category}"
          puts "  Quantity: #{item.quantity}"
          puts "  Base Price: ₹#{item.product.price}"
          puts "  Total: ₹#{item.product.price * item.quantity}"
        end

        puts "\nCustomer Tier: #{context.customer.tier}"
        puts "Payment Method: #{context.payment_info.payment_method} " + 
             (context.payment_info.bank_name ? "(#{context.payment_info.bank_name} #{context.payment_info.card_type})" : "")

        # Print available discounts for this test
        puts "\nAvailable Discounts:"
        test_case[:discounts].each do |discount|
          puts "  #{discount.name} (#{discount.code if discount.respond_to?(:code)})"
        end

        # Print expected vs applied discounts
        puts "\nExpected Discounts: #{test_case[:expected_discounts].join(', ')}"
        puts "Applied Discounts:"
        result.applied_discounts.each do |discount|
          puts "  #{discount}"
        end

        puts "\nOriginal Total: ₹#{result.original_price}"
        puts "Final Total: ₹#{result.final_price}"
        puts "Total Savings: ₹#{result.original_price - result.final_price}"
        puts "\n----------------------------------------\n\n"
      end
    end
  end
end

# Run the tests if this file is being run directly
if __FILE__ == $PROGRAM_NAME
  DiscountingApp::TestRunner.run
end 