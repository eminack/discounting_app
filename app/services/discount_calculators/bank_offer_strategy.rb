require 'bigdecimal'

module DiscountCalculators
  class BankOfferStrategy
    include DiscountStrategyInterface

    def initialize(bank_offers)
      @bank_offers = bank_offers # Hash of bank_name => {card_types:, discount_percentage:, min_cart_value:}
    end

    def applicable?(cart_items, _customer, payment_info = nil)
      return false unless payment_info
      return false unless payment_info.payment_method == Enums::PaymentMethod::CARD
      
      if offer = @bank_offers[payment_info.bank_name]
        cart_total = calculate_cart_total(cart_items)
        return cart_total >= offer[:min_cart_value] && offer[:card_types].include?(payment_info.card_type)
      end
      
      false
    end

    def apply(cart_items, _customer, payment_info)
      offer = @bank_offers[payment_info.bank_name]
      cart_total = calculate_cart_total(cart_items)
      discount_amount = cart_total * (offer[:discount_percentage] / 100.0)
      updated_cart_price = cart_total - discount_amount

      {
        discount_name: "Bank Offer (#{payment_info.bank_name})",
        discount_amount: format_discount_amount(discount_amount),
        updated_cart_price: format_discount_amount(updated_cart_price)
      }
    end
  end 
end