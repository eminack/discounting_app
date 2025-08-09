module DiscountStrategies
  class BankCardOfferDiscountStrategy
    include ActiveModel::Model
    include DiscountValidationInterface

    attr_accessor :bank_name, :card_types, :percentage
    def initialize(attributes)
      @bank_name = attributes[:bank_name]
      @card_types = attributes[:card_types]
      @percentage = attributes[:percentage]
    end

    validates :bank_name, :percentage, presence: true

    def valid_for_context?(context)
      return false unless valid?
      context.payment_info.bank_name == bank_name && context.payment_info.card_type.in?(card_types)
    end

    def calculator_class
      DiscountCalculators::BankCardOfferCalculator
    end
  end
end