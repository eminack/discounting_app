require 'bigdecimal'

module DiscountingApp
  module Models
    class DiscountedPrice
      attr_reader :original_price, :final_price, :applied_discounts, :messages

      # Initialize a new DiscountedPrice
      # @param original_price [Numeric] Original price before discounts
      def initialize(original_price)
        @original_price = BigDecimal(original_price.to_s)
        @final_price = @original_price
        @applied_discounts = {}
        @messages = []
      end

      # Apply a discount with a specific name and amount
      # @param name [String] Name of the discount
      # @param percentage [Numeric] Discount percentage
      # @param message [String] Description of the discount
      def apply_discount(name:, percentage:, message:)
        validate_percentage!(percentage)

        discount_amount = calculate_discount_amount(percentage)
        @final_price -= discount_amount

        @applied_discounts[name] = discount_amount
        @messages << message
      end

      # Get total discount amount
      # @return [BigDecimal] Sum of all applied discounts
      def total_discount
        @applied_discounts.values.sum
      end

      # Get discount summary
      # @return [String] Human-readable summary of applied discounts
      def summary
        return 'No discounts applied' if @applied_discounts.empty?

        summary = ["Original price: #{format_price(@original_price)}"]
        @applied_discounts.each do |name, amount|
          summary << "#{name}: -#{format_price(amount)}"
        end
        summary << "Final price: #{format_price(@final_price)}"
        summary.join("\n")
      end

      private

      def calculate_discount_amount(percentage)
        discount_multiplier = percentage / 100.0
        (@final_price * BigDecimal(discount_multiplier.to_s)).round(2)
      end

      def validate_percentage!(percentage)
        return if percentage.is_a?(Numeric) && percentage >= 0 && percentage <= 100

        raise ArgumentError, "Invalid discount percentage: #{percentage}. Must be between 0 and 100"
      end

      def format_price(price)
        format('₹%.2f', price)
      end
    end
  end
end
