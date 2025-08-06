require_relative 'product'

module DiscountingApp
  module Models
    # CartItem data class
    CartItem = Struct.new(:product, :quantity, :cart_size, keyword_init: true) do
      def initialize(*)
        super
        validate!
      end

      private

      def validate!
        raise ArgumentError, 'Quantity must be positive' unless quantity.is_a?(Integer) && quantity.positive?
        raise ArgumentError, 'Product is required' unless product.is_a?(Product)
      end
    end
  end
end
