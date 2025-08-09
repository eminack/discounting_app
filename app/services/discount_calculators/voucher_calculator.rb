require 'bigdecimal'

module DiscountCalculators
  class VoucherCalculator
    include DiscountCalculatorInterface

    def calculate_discount(context, discount_obj)
      return {
        name: discount_obj.name,
        total_discount: 0,
        discounted_items: []
      } unless validate_discount_code(discount_obj, context)

      discounted_items = []
      cart_item = eligible_item(context, discount_obj)
      # if no eligible item, return 0 discount
      return { 
        name: discount_obj.name,
        total_discount: 0,
        discounted_items: []
      } if cart_item.nil?

      original_price = cart_item.product.current_price * cart_item.quantity
      item_discount = calculate_item_discount(cart_item, discount_obj.strategy.percentage)
      total_discount = BigDecimal(item_discount.to_s)
      discounted_items << {
        item: cart_item,
        original_price: original_price,
        discount: item_discount,
        final_price: original_price - item_discount
      }

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

    def eligible_item(context, discount_obj)
      # find the eligible item with max current price, return the item with max current price
      context.cart.cart_items.select { |cart_item| discount_obj.strategy.valid_for_cart_item?(cart_item) }.max_by { |cart_item| cart_item.product.current_price }
    end

  end 
end