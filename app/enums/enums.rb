module DiscountingApp
  module Enums
    # Base enum module with common functionality
    module EnumBase
      def values
        constants.map { |c| const_get(c) }
      end

      def valid?(value)
        values.include?(value)
      end
    end

    # Brand tier classification
    module BrandTier
      extend EnumBase

      PREMIUM = :premium
      REGULAR = :regular
      BUDGET = :budget
    end

    # Payment methods
    module PaymentMethod
      extend EnumBase

      CARD = :card
      UPI = :upi
      NETBANKING = :netbanking
      WALLET = :wallet
    end

    # Card types
    module CardType
      extend EnumBase

      CREDIT = :credit
      DEBIT = :debit
    end

    # Customer tiers
    module CustomerTier
      extend EnumBase

      PLATINUM = :platinum
      GOLD = :gold
      SILVER = :silver
      REGULAR = :regular
    end
  end
end
