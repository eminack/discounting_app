require 'bigdecimal'

module DiscountCalculators
  class BrandDiscountStrategy
    include DiscountStrategyInterface

    def initialize(brand_discounts)
      @brand_discounts = brand_discounts # Hash of brand => discount_percentage
    end

    def applicable?(cart_items, customer, _payment_info = nil)
      cart_items.any? { |item| @brand_discounts.key?(item.product.brand) }
    end

    def apply(cart_items, customer, _payment_info = nil)
      total_discount = BigDecimal('0')
      updated_cart_price = BigDecimal('0')

      cart_items.each do |item|
        if @brand_discounts.key?(item.product.brand)
          item_total = item.product.base_price * item.quantity
          discount_percentage = @brand_discounts[item.product.brand]
          item_discount = item_total * (discount_percentage / 100.0)
          
          total_discount += format_discount_amount(item_discount)
          updated_cart_price += item_total - item_discount
        else
          updated_cart_price += item.product.base_price * item.quantity
        end
      end

      {
        discount_name: "Brand Discount",
        discount_amount: total_discount,
        updated_cart_price: format_discount_amount(updated_cart_price)
      }
    end
  end 
end