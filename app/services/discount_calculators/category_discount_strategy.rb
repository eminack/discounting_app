require 'bigdecimal'

module DiscountCalculators
  class CategoryDiscountStrategy
    include DiscountStrategyInterface

    def initialize(category_discounts)
      @category_discounts = category_discounts # Hash of category => discount_percentage
    end

    def applicable?(cart_items, customer, _payment_info = nil)
      cart_items.any? { |item| @category_discounts.key?(item.product.category) }
    end

    def apply(cart_items, customer, _payment_info = nil)
      total_discount = BigDecimal('0')
      updated_cart_price = BigDecimal('0')

      cart_items.each do |item|
        if @category_discounts.key?(item.product.category)
          item_total = item.product.base_price * item.quantity
          discount_percentage = @category_discounts[item.product.category]
          item_discount = item_total * (discount_percentage / 100.0)
          
          total_discount += format_discount_amount(item_discount)
          updated_cart_price += item_total - item_discount
        else
          updated_cart_price += item.product.base_price * item.quantity
        end
      end

      {
        discount_name: "Category Discount",
        discount_amount: total_discount,
        updated_cart_price: format_discount_amount(updated_cart_price)
      }
    end
  end 
end