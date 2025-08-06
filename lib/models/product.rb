require 'bigdecimal'
require_relative 'enums'

module DiscountingApp
  module Models
    class Product
      attr_reader :id, :brand, :brand_tier, :category, :base_price
      attr_accessor :current_price

      # Initialize a new Product
      # @param id [Integer] Product ID
      # @param brand [String] Brand name
      # @param brand_tier [String] Brand tier (premium, regular, budget)
      # @param category [String] Product category
      # @param base_price [Numeric] Original price
      def initialize(id:, brand:, brand_tier:, category:, base_price:)
        @id = id
        @brand = brand
        @category = category
        @base_price = BigDecimal(base_price.to_s)
        @current_price = @base_price

        validate_brand_tier!(brand_tier)
        @brand_tier = brand_tier
      end

      # Reset current price to base price
      def reset_price!
        @current_price = @base_price
      end

      # Apply a discount percentage to current price
      # @param percentage [Numeric] Discount percentage (0-100)
      def apply_discount_percentage(percentage)
        validate_percentage!(percentage)
        discount_multiplier = (100 - percentage) / 100.0
        @current_price = (@current_price * BigDecimal(discount_multiplier.to_s)).round(2)
      end

      private

      def validate_brand_tier!(tier)
        return if Enums::BrandTier.valid?(tier)

        raise ArgumentError, "Invalid brand tier: #{tier}. Must be one of: #{Enums::BrandTier.all.join(', ')}"
      end

      def validate_percentage!(percentage)
        return if percentage.is_a?(Numeric) && percentage >= 0 && percentage <= 100

        raise ArgumentError, "Invalid discount percentage: #{percentage}. Must be between 0 and 100"
      end
    end
  end
end
