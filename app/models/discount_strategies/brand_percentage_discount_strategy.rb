module DiscountStrategies
  class BrandPercentageDiscountStrategy
    include ActiveModel::Model
    include DiscountValidationInterface
    
    attr_accessor :brand, :percentage
    def initialize(attributes)
      @brand = attributes[:brand]
      @percentage = attributes[:percentage]
    end

    validates :brand, :percentage, presence: true
    validates :percentage, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

    def valid_for_context?(context)
      return false unless valid?
      context.cart.cart_items.any? { |cart_item| valid_for_cart_item?(cart_item) }
    end

    def valid_for_cart_item?(cart_item)
      return false unless valid?
      cart_item.product.brand == brand
    end

    def calculator_class
      DiscountCalculators::BrandPercentageCalculator
    end
  end
end