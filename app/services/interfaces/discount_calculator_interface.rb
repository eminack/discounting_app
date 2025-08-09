require 'bigdecimal'

module DiscountCalculatorInterface
  def calculate_discount(context, discount_obj)
    raise NotImplementedError, "#{self.class} must implement #calculate_discount"
  end

  def validate_discount_code(discount, context)
    raise NotImplementedError, "#{self.class} must implement #validate_discount_code"
  end

  def self.included(base)
    base.class_eval do
      def self.implements_interface?
        instance_methods(false).include?(:calculate_discount) &&
          instance_methods(false).include?(:validate_discount_code)
      end
    end
  end
end 