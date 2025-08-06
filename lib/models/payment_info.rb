require_relative 'enums'

module DiscountingApp
  module Models
    # PaymentInfo data class
    PaymentInfo = Struct.new(:payment_method, :bank_name, :card_type, keyword_init: true) do
      def initialize(*)
        super
        validate!
      end

      private

      def validate!
        raise ArgumentError, 'Invalid payment method' unless Enums::PaymentMethod.valid?(payment_method)

        return unless payment_method == Enums::PaymentMethod::CARD
        raise ArgumentError, 'Bank name is required for card payments' if bank_name.nil? || bank_name.empty?
        raise ArgumentError, 'Invalid card type' unless Enums::CardType.valid?(card_type)
      end
    end
  end
end
