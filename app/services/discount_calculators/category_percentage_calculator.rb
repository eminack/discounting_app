require 'bigdecimal'

module DiscountCalculators
  class CategoryPercentageCalculator
    include DiscountCalculatorInterface

    def calculate_discount(context, discount_obj)
      return {
        name: discount_obj.name,
        total_discount: 0,
        discounted_items: []
      } unless validate_discount_code(discount_obj, context)

      total_discount = BigDecimal('0')
      discounted_items = []

      eligible_items(context, discount_obj).each do |cart_item|
        original_price = cart_item.product.current_price * cart_item.quantity
        item_discount = calculate_item_discount(cart_item, discount_obj.strategy.percentage)
        total_discount += item_discount
        discounted_items << {
          item: cart_item,
          original_price: original_price,
          discount: item_discount,
          final_price: original_price - item_discount
        }
      end

      {
        name: discount_obj.name,
        total_discount: total_discount,
        discounted_items: discounted_items
      }
    end

    def validate_discount_code(discount, context)
      discount.validate_discount_code(context)
    end

    private

    def calculate_item_discount(cart_item, percentage)
      single_item_discounted_price = cart_item.product.current_price * percentage / 100.0
      cart_item.product.current_price = cart_item.product.current_price - single_item_discounted_price
      single_item_discounted_price * cart_item.quantity
    end

    def eligible_items(context, discount_obj)
      context.cart.cart_items.select { |cart_item| discount_obj.strategy.valid_for_cart_item?(cart_item) }
    end
  end 
end