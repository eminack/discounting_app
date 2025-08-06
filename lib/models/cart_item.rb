require 'bigdecimal'
require_relative 'product'

module DiscountingApp
  module Models
    class CartItem
      attr_reader :product, :quantity, :size

      # Initialize a new CartItem
      # @param product [Product] Product instance
      # @param quantity [Integer] Quantity of the product
      # @param size [String] Size of the product (if applicable)
      def initialize(product:, quantity:, size: nil)
        @product = product
        validate_quantity!(quantity)
        @quantity = quantity
        @size = size
      end

      # Calculate the total price for this cart item
      # @return [BigDecimal] Total price (current_price * quantity)
      def total_price
        BigDecimal(product.current_price.to_s) * quantity
      end

      # Calculate the total base price for this cart item
      # @return [BigDecimal] Total base price (base_price * quantity)
      def total_base_price
        BigDecimal(product.base_price.to_s) * quantity
      end

      private

      def validate_quantity!(quantity)
        return if quantity.is_a?(Integer) && quantity > 0

        raise ArgumentError, "Invalid quantity: #{quantity}. Must be a positive integer"
      end
    end
  end
end
