require 'bigdecimal'

module DiscountingApp
  module Models
    # DiscountedPrice data class to hold price and discount information
    DiscountedPrice = Struct.new(:original_price, :final_price, :applied_discounts, :messages, keyword_init: true) do
      def initialize(*)
        super
        self.original_price = BigDecimal(original_price.to_s)
        self.final_price ||= original_price
        self.applied_discounts ||= {}
        self.messages ||= []
        validate!
      end

      private

      def validate!
        raise ArgumentError, 'Original price must be positive' unless original_price.positive?
        raise ArgumentError, 'Final price must be positive' unless final_price.positive?
        raise ArgumentError, 'Final price cannot be greater than original price' unless final_price <= original_price
      end
    end
  end
end
