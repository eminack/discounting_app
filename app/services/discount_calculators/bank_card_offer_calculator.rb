require 'bigdecimal'

module DiscountCalculators
  class BankCardOfferCalculator
    include DiscountCalculatorInterface

    def calculate_discount(context, discount_obj)
      return {
        name: discount_obj.name,
        total_discount: 0,
        discounted_items: []
      } unless validate_discount_code(discount_obj, context)

      cart_total = calculate_cart_total(context.cart.cart_items)
      discount_amount = cart_total * (discount_obj.strategy.percentage / 100.0)
      updated_cart_price = cart_total - discount_amount
      discounted_items = []
      discounted_items << {
        item: [],
        original_price: cart_total,
        discount: discount_amount,
        final_price: updated_cart_price
      }

      {
        name: discount_obj.name,
        total_discount: format_discount_amount(discount_amount),
        discounted_items: discounted_items
      }
    end

    def validate_discount_code(discount, context)
      discount.validate_discount_code(context)
    end

    private

    def calculate_cart_total(cart_items)
      cart_items.sum { |cart_item| cart_item.product.current_price * cart_item.quantity }
    end

    def format_discount_amount(amount)
      BigDecimal(amount.to_s).round(2)
    end
  end 
end