module DiscountStrategies
  class CategoryPercentageDiscountStrategy
    include ActiveModel::Model
    include DiscountValidationInterface

    attr_accessor :category, :percentage

    validates :category, :percentage, presence: true

    def initialize(attributes)
      @category = attributes[:category]
      @percentage = attributes[:percentage]
    end
  
    def valid_for_context?(context)
      return false unless valid?
      context.cart.cart_items.any? { |cart_item| valid_for_cart_item?(cart_item) }
    end

    def valid_for_cart_item?(cart_item)
      return false unless valid?
      cart_item.product.category == category
    end

    def calculator_class
      DiscountCalculators::CategoryPercentageCalculator
    end
  end
end