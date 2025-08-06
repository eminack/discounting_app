require 'bigdecimal'
require_relative 'enums'

module DiscountingApp
  module Models
    # Product data class
    Product = Struct.new(:id, :brand, :brand_tier, :category, :base_price, :current_price, keyword_init: true) do
      def initialize(*)
        super
        self.base_price = BigDecimal(base_price.to_s)
        self.current_price ||= base_price
        validate!
      end

      private

      def validate!
        raise ArgumentError, 'Invalid brand tier' unless Enums::BrandTier.valid?(brand_tier)
      end
    end
  end
end
