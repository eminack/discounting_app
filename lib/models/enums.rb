module DiscountingApp
  module Enums
    # Brand tier classification
    module BrandTier
      PREMIUM = 'premium'
      REGULAR = 'regular'
      BUDGET = 'budget'

      def self.all
        [PREMIUM, REGULAR, BUDGET]
      end

      def self.valid?(tier)
        all.include?(tier.to_s.downcase)
      end
    end

    # Payment methods
    module PaymentMethod
      CARD = 'card'
      UPI = 'upi'
      NETBANKING = 'netbanking'
      WALLET = 'wallet'

      def self.all
        [CARD, UPI, NETBANKING, WALLET]
      end

      def self.valid?(method)
        all.include?(method.to_s.downcase)
      end
    end

    # Card types
    module CardType
      CREDIT = 'credit'
      DEBIT = 'debit'

      def self.all
        [CREDIT, DEBIT]
      end

      def self.valid?(type)
        all.include?(type.to_s.downcase)
      end
    end

    # Customer tiers
    module CustomerTier
      PLATINUM = 'platinum'
      GOLD = 'gold'
      SILVER = 'silver'
      REGULAR = 'regular'

      def self.all
        [PLATINUM, GOLD, SILVER, REGULAR]
      end

      def self.valid?(tier)
        all.include?(tier.to_s.downcase)
      end
    end
  end
end
