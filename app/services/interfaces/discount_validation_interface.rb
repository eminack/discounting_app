require 'bigdecimal'

module DiscountValidationInterface
  def valid_for_context?(context)
    raise NotImplementedError, "#{self.class} must implement #valid_for_context?"
  end

  def calculator_class
    raise NotImplementedError, "#{self.class} must implement #calculator_class"
  end

  def self.included(base)
    base.class_eval do
      def self.implements_interface?
        instance_methods(false).include?(:valid_for_context?) &&
          instance_methods(false).include?(:calculator_class)
      end
    end
  end
end 