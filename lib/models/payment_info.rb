require_relative 'enums'

module DiscountingApp
  module Models
    class PaymentInfo
      attr_reader :method, :bank_name, :card_type

      # Initialize payment information
      # @param method [String] Payment method (CARD, UPI, etc.)
      # @param bank_name [String, nil] Bank name (required for CARD method)
      # @param card_type [String, nil] Card type (required for CARD method)
      def initialize(method:, bank_name: nil, card_type: nil)
        validate_payment_method!(method)
        @method = method.downcase

        return unless @method == Enums::PaymentMethod::CARD

        validate_card_payment!(bank_name, card_type)
        @bank_name = bank_name
        @card_type = card_type.downcase
      end

      # Check if this is a card payment
      # @return [Boolean]
      def card_payment?
        method == Enums::PaymentMethod::CARD
      end

      # Check if this is a specific bank's card
      # @param bank [String] Bank name to check
      # @return [Boolean]
      def bank_card?(bank)
        card_payment? && bank_name&.downcase == bank.downcase
      end

      private

      def validate_payment_method!(method)
        return if Enums::PaymentMethod.valid?(method)

        raise ArgumentError,
              "Invalid payment method: #{method}. Must be one of: #{Enums::PaymentMethod.all.join(', ')}"
      end

      def validate_card_payment!(bank_name, card_type)
        raise ArgumentError, 'Bank name is required for card payments' if bank_name.nil? || bank_name.empty?

        return if Enums::CardType.valid?(card_type)

        raise ArgumentError, "Invalid card type: #{card_type}. Must be one of: #{Enums::CardType.all.join(', ')}"
      end
    end
  end
end
