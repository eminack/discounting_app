module DiscountStrategies
  class VoucherDiscountStrategy
    include ActiveModel::Model
    include DiscountValidationInterface

    def initialize(attributes)
      @code = attributes[:code]
      @percentage = attributes[:percentage]
      @excluded_brands = attributes[:excluded_brands]
      @excluded_categories = attributes[:excluded_categories]
    end

    ###
    # Assumptions:
    # this Discount is only applied to all quantity of a product & product is selected whose current price is maximum
    ###e
    attr_accessor :code, :percentage, :excluded_brands, :excluded_categories

    validates :code, :percentage, presence: true

    def valid_for_context?(context)
      return false unless valid?
      context.cart.cart_items.any? do |cart_item|
        valid_for_cart_item?(cart_item)
      end
    end

    def valid_for_cart_item?(cart_item)
      return false unless valid?
      !excluded_brands.include?(cart_item.product.brand) &&
      !excluded_categories.include?(cart_item.product.category)
    end

    def calculator_class
      DiscountCalculators::VoucherCalculator
    end
  end
end