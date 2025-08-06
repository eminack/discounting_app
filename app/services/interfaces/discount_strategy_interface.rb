require 'bigdecimal'

module DiscountStrategyInterface
  def applicable?(cart_items, customer, payment_info = nil)
    raise NotImplementedError, "#{self.class} must implement #applicable?"
  end

  def apply(cart_items, customer, payment_info = nil)
    raise NotImplementedError, "#{self.class} must implement #apply"
  end

  def self.included(base)
    base.class_eval do
      def self.implements_interface?
        instance_methods(false).include?(:applicable?) &&
          instance_methods(false).include?(:apply)
      end
    end
  end

  protected

  def calculate_cart_total(cart_items)
    cart_items.sum { |item| item.product.base_price * item.quantity }
  end

  def format_discount_amount(amount)
    BigDecimal(amount.to_s).round(2)
  end
end 