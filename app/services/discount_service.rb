require 'bigdecimal'

class DiscountService
  attr_reader :discounts

  def initialize(discounts)
    @discounts = discounts
  end

  def calculate_cart_discounts(context)
    sorted_discounts = discounts.sort_by { |discount| DiscountingApp::Enums::DiscountStrategy.sorted_discounts.index(discount.strategy) }
    applied_discounts = sorted_discounts.map { |discount| discount.apply(context) }.compact
    create_discounted_price(context, applied_discounts)
  end

  def validate_discount_code(code, context)
    discount = discounts.find { |discount| discount.code == code }
    raise StandardError, "Invalid discount code" unless discount
    discount.validate_discount_code(context)
  end

  private

  def create_discounted_price(context, applied_discounts)
    original_price = context.cart.cart_items.sum { |cart_item| cart_item.product.price * cart_item.quantity }
    total_discount = applied_discounts.sum { |discount| discount[:total_discount].to_f }
    final_price = original_price - total_discount
    DiscountedPrice.new(
      original_price: context.cart.cart_items.sum { |cart_item| cart_item.product.price * cart_item.quantity },
      applied_discounts: applied_discounts.map { |discount| { discount[:name] => discount[:total_discount].to_f } },
      final_price: ,
      messages: applied_discounts.map { |discount| generate_discount_message(discount) }
    )
  end

  def generate_discount_message(discount)
    "Applied #{discount[:name]}: -#{format_currency(discount[:total_discount])}"
  end

  def format_currency(amount)
    format('%.2f', amount)
  end
end 