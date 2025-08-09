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

    # Brands
    module Brand
      extend EnumBase

      NIKE = :nike
      PUMA = :puma
      ADIDAS = :adidas
      REEBOK = :reebok
      UNDER_ARMOUR = :under_armour
    end

    # Categories
    module Category
      extend EnumBase

      FOOTWEAR = :footwear
      APPAREL = :apparel
      ACCESSORIES = :accessories
      EQUIPMENT = :equipment
      BAGS = :bags
    end

    # Banks
    module Bank
      extend EnumBase

      ICICI = :icici
      HDFC = :hdfc
      AXIS = :axis
      SBI = :sbi
      KOTAK = :kotak
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

    module DiscountStrategy
      extend EnumBase

      BANK_OFFER = :bank_offer
      BRAND_PERCENTAGE_DISCOUNT = :brand_percentage_discount
      CATEGORY_PERCENTAGE_DISCOUNT = :category_percentage_discount
      VOUCHER_DISCOUNT = :voucher_discount

      def self.sorted_discounts
        [BRAND_PERCENTAGE_DISCOUNT, CATEGORY_PERCENTAGE_DISCOUNT, VOUCHER_DISCOUNT, BANK_OFFER]
      end
    end
  end
end
