#!/usr/bin/env ruby

require_relative '../config/environment'

module DiscountingApp
  module TestCases
    class DiscountTestCases
      def self.get_test_cases
        [
          # Test Case 1: Multiple items with brand discount (PUMA40)
          {
            name: "Brand Discount - PUMA items",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 1,
                  brand: Enums::Brand::PUMA,
                  brand_tier: Enums::BrandTier::REGULAR,
                  category: Enums::Category::APPAREL,
                  price: 1999,
                  current_price: 1999
                ),
                quantity: 2
              ),
              CartItem.new(
                product: Product.new(
                  id: 2,
                  brand: Enums::Brand::PUMA,
                  brand_tier: Enums::BrandTier::BUDGET,
                  category: Enums::Category::ACCESSORIES,
                  price: 499,
                  current_price: 499
                ),
                quantity: 1
              )
            ],
            customer: CustomerProfile.new(
              id: 1,
              tier: Enums::CustomerTier::REGULAR
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::CARD,
              bank_name: Enums::Bank::HDFC,
              card_type: Enums::CardType::DEBIT
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::BRAND_PERCENTAGE_DISCOUNT, {
                name: 'Puma 40% Off',
                code: 'PUMA40',
                brand: Enums::Brand::PUMA,
                percentage: 40,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: ['PUMA40']
          },

          # Test Case 2: Premium footwear with category discount
          {
            name: "Category Discount - Premium Footwear",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 3,
                  brand: Enums::Brand::NIKE,
                  brand_tier: Enums::BrandTier::PREMIUM,
                  category: Enums::Category::FOOTWEAR,
                  price: 8999,
                  current_price: 8999
                ),
                quantity: 1
              )
            ],
            customer: CustomerProfile.new(
              id: 2,
              tier: Enums::CustomerTier::PLATINUM
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::CARD,
              bank_name: Enums::Bank::ICICI,
              card_type: Enums::CardType::CREDIT
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::CATEGORY_PERCENTAGE_DISCOUNT, {
                name: 'Premium Footwear 30% Off',
                code: 'PREMIUM30',
                category: Enums::Category::FOOTWEAR,
                percentage: 30,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              }),
              DiscountFactory.build(Enums::DiscountStrategy::BANK_OFFER, {
                name: 'ICICI Premium Offer',
                code: 'ICICI15',
                bank_name: Enums::Bank::ICICI,
                card_types: [Enums::CardType::CREDIT],
                percentage: 15,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: ['PREMIUM30', 'ICICI15']
          },

          # Test Case 3: Mixed cart with bank offer
          {
            name: "Bank Offer - ICICI Credit Card",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 4,
                  brand: Enums::Brand::ADIDAS,
                  brand_tier: Enums::BrandTier::PREMIUM,
                  category: Enums::Category::APPAREL,
                  price: 2499,
                  current_price: 2499
                ),
                quantity: 2
              ),
              CartItem.new(
                product: Product.new(
                  id: 5,
                  brand: Enums::Brand::REEBOK,
                  brand_tier: Enums::BrandTier::REGULAR,
                  category: Enums::Category::FOOTWEAR,
                  price: 3999,
                  current_price: 3999
                ),
                quantity: 1
              )
            ],
            customer: CustomerProfile.new(
              id: 3,
              tier: Enums::CustomerTier::GOLD
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::CARD,
              bank_name: Enums::Bank::ICICI,
              card_type: Enums::CardType::CREDIT
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::BANK_OFFER, {
                name: 'ICICI Special Offer',
                code: 'ICICI20',
                bank_name: Enums::Bank::ICICI,
                card_types: [Enums::CardType::CREDIT],
                percentage: 20,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: ['ICICI20']
          },

          # Test Case 4: Summer sale voucher with exclusions
          {
            name: "Voucher Discount - Summer Sale with Exclusions",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 6,
                  brand: Enums::Brand::PUMA,
                  brand_tier: Enums::BrandTier::REGULAR,
                  category: Enums::Category::APPAREL,
                  price: 1499,
                  current_price: 1499
                ),
                quantity: 1
              ),
              CartItem.new(
                product: Product.new(
                  id: 7,
                  brand: Enums::Brand::NIKE,
                  brand_tier: Enums::BrandTier::PREMIUM,
                  category: Enums::Category::FOOTWEAR,
                  price: 6999,
                  current_price: 6999
                ),
                quantity: 1
              )
            ],
            customer: CustomerProfile.new(
              id: 4,
              tier: Enums::CustomerTier::REGULAR
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::UPI,
              bank_name: nil,
              card_type: nil
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::VOUCHER_DISCOUNT, {
                name: 'Summer Special Sale',
                code: 'SUMMER50',
                percentage: 50,
                excluded_brands: [Enums::Brand::NIKE],
                excluded_categories: [Enums::Category::ACCESSORIES],
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: ['SUMMER50']
          },

          # Test Case 5: Multiple applicable discounts
          {
            name: "Multiple Discounts - Brand, Category, and Bank",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 8,
                  brand: Enums::Brand::PUMA,
                  brand_tier: Enums::BrandTier::REGULAR,
                  category: Enums::Category::FOOTWEAR,
                  price: 4999,
                  current_price: 4999
                ),
                quantity: 1
              )
            ],
            customer: CustomerProfile.new(
              id: 5,
              tier: Enums::CustomerTier::PLATINUM
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::CARD,
              bank_name: Enums::Bank::ICICI,
              card_type: Enums::CardType::CREDIT
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::BRAND_PERCENTAGE_DISCOUNT, {
                name: 'Puma Special Discount',
                code: 'PUMA35',
                brand: Enums::Brand::PUMA,
                percentage: 35,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              }),
              DiscountFactory.build(Enums::DiscountStrategy::CATEGORY_PERCENTAGE_DISCOUNT, {
                name: 'Footwear Season Sale',
                code: 'FOOT25',
                category: Enums::Category::FOOTWEAR,
                percentage: 25,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              }),
              DiscountFactory.build(Enums::DiscountStrategy::BANK_OFFER, {
                name: 'ICICI Weekend Offer',
                code: 'ICICI12',
                bank_name: Enums::Bank::ICICI,
                card_types: [Enums::CardType::CREDIT],
                percentage: 12,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: ['PUMA35', 'FOOT25', 'ICICI12']
          },

          # Test Case 6: Budget items with no applicable discounts
          {
            name: "No Discounts - Budget Items",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 9,
                  brand: Enums::Brand::REEBOK,
                  brand_tier: Enums::BrandTier::BUDGET,
                  category: Enums::Category::ACCESSORIES,
                  price: 299,
                  current_price: 299
                ),
                quantity: 3
              )
            ],
            customer: CustomerProfile.new(
              id: 6,
              tier: Enums::CustomerTier::REGULAR
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::UPI,
              bank_name: nil,
              card_type: nil
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::CATEGORY_PERCENTAGE_DISCOUNT, {
                name: 'Budget Items Sale',
                code: 'BUDGET20',
                category: Enums::Category::APPAREL,
                percentage: 20,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: []
          },

          # Test Case 7: High-value premium purchase with netbanking
          {
            name: "Premium Purchase - Multiple Items",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 10,
                  brand: Enums::Brand::NIKE,
                  brand_tier: Enums::BrandTier::PREMIUM,
                  category: Enums::Category::FOOTWEAR,
                  price: 12999,
                  current_price: 12999
                ),
                quantity: 1
              ),
              CartItem.new(
                product: Product.new(
                  id: 11,
                  brand: Enums::Brand::NIKE,
                  brand_tier: Enums::BrandTier::PREMIUM,
                  category: Enums::Category::APPAREL,
                  price: 4999,
                  current_price: 4999
                ),
                quantity: 2
              )
            ],
            customer: CustomerProfile.new(
              id: 7,
              tier: Enums::CustomerTier::PLATINUM
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::NETBANKING,
              bank_name: Enums::Bank::ICICI,
              card_type: nil
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::BRAND_PERCENTAGE_DISCOUNT, {
                name: 'Nike Premium Sale',
                code: 'NIKE30',
                brand: Enums::Brand::NIKE,
                percentage: 30,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              }),
              DiscountFactory.build(Enums::DiscountStrategy::BANK_OFFER, {
                name: 'HDFC Netbanking Offer',
                code: 'HDFC8',
                bank_name: Enums::Bank::HDFC,
                card_types: [],  # Empty for netbanking
                percentage: 8,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: ['NIKE30']
          },

          # Test Case 8: Mixed brands with voucher and wallet payment
          {
            name: "Mixed Brands - Voucher Discount",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 12,
                  brand: Enums::Brand::PUMA,
                  brand_tier: Enums::BrandTier::REGULAR,
                  category: Enums::Category::APPAREL,
                  price: 2499,
                  current_price: 2499
                ),
                quantity: 1
              ),
              CartItem.new(
                product: Product.new(
                  id: 13,
                  brand: Enums::Brand::ADIDAS,
                  brand_tier: Enums::BrandTier::REGULAR,
                  category: Enums::Category::FOOTWEAR,
                  price: 5999,
                  current_price: 5999
                ),
                quantity: 1
              )
            ],
            customer: CustomerProfile.new(
              id: 8,
              tier: Enums::CustomerTier::GOLD
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::WALLET,
              bank_name: nil,
              card_type: nil
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::BRAND_PERCENTAGE_DISCOUNT, {
                name: 'Puma Clearance',
                code: 'PUMA45',
                brand: Enums::Brand::PUMA,
                percentage: 45,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              }),
              DiscountFactory.build(Enums::DiscountStrategy::VOUCHER_DISCOUNT, {
                name: 'Clearance Sale',
                code: 'CLEAR40',
                percentage: 40,
                excluded_brands: [Enums::Brand::NIKE],
                excluded_categories: [],
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: ['PUMA45', 'CLEAR40']
          },

          # Test Case 9: Single premium item with multiple discounts
          {
            name: "Single Premium Item - Multiple Discounts",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 14,
                  brand: Enums::Brand::PUMA,
                  brand_tier: Enums::BrandTier::PREMIUM,
                  category: Enums::Category::FOOTWEAR,
                  price: 9999,
                  current_price: 9999
                ),
                quantity: 1
              )
            ],
            customer: CustomerProfile.new(
              id: 9,
              tier: Enums::CustomerTier::PLATINUM
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::CARD,
              bank_name: Enums::Bank::ICICI,
              card_type: Enums::CardType::CREDIT
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::BRAND_PERCENTAGE_DISCOUNT, {
                name: 'Nike Premium Sale',
                code: 'NIKEPREM',
                brand: Enums::Brand::NIKE,
                percentage: 35,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              }),
              DiscountFactory.build(Enums::DiscountStrategy::CATEGORY_PERCENTAGE_DISCOUNT, {
                name: 'Premium Footwear Sale',
                code: 'PREMIUM25',
                category: Enums::Category::FOOTWEAR,
                percentage: 25,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              }),
              DiscountFactory.build(Enums::DiscountStrategy::BANK_OFFER, {
                name: 'HDFC Premium Card Offer',
                code: 'HDFC15',
                bank_name: Enums::Bank::HDFC,
                card_types: [Enums::CardType::CREDIT],
                percentage: 15,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: ['PREMIUM25']
          },

          # Test Case 10: Bulk purchase with mixed categories
          {
            name: "Bulk Purchase - Mixed Categories",
            cart_items: [
              CartItem.new(
                product: Product.new(
                  id: 15,
                  brand: Enums::Brand::PUMA,
                  brand_tier: Enums::BrandTier::REGULAR,
                  category: Enums::Category::APPAREL,
                  price: 1999,
                  current_price: 1999
                ),
                quantity: 3
              ),
              CartItem.new(
                product: Product.new(
                  id: 16,
                  brand: Enums::Brand::PUMA,
                  brand_tier: Enums::BrandTier::REGULAR,
                  category: Enums::Category::FOOTWEAR,
                  price: 3999,
                  current_price: 3999
                ),
                quantity: 2
              ),
              CartItem.new(
                product: Product.new(
                  id: 17,
                  brand: Enums::Brand::PUMA,
                  brand_tier: Enums::BrandTier::BUDGET,
                  category: Enums::Category::ACCESSORIES,
                  price: 499,
                  current_price: 499
                ),
                quantity: 4
              )
            ],
            customer: CustomerProfile.new(
              id: 10,
              tier: Enums::CustomerTier::GOLD
            ),
            payment_info: PaymentInfo.new(
              payment_method: Enums::PaymentMethod::CARD,
              bank_name: Enums::Bank::ICICI,
              card_type: Enums::CardType::CREDIT
            ),
            discounts: [
              DiscountFactory.build(Enums::DiscountStrategy::BRAND_PERCENTAGE_DISCOUNT, {
                name: 'Puma Bulk Discount',
                code: 'PUMABULK',
                brand: Enums::Brand::PUMA,
                percentage: 50,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              }),
              DiscountFactory.build(Enums::DiscountStrategy::CATEGORY_PERCENTAGE_DISCOUNT, {
                name: 'Footwear Bulk Sale',
                code: 'BULKFOOT',
                category: Enums::Category::FOOTWEAR,
                percentage: 30,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              }),
              DiscountFactory.build(Enums::DiscountStrategy::BANK_OFFER, {
                name: 'ICICI Big Purchase Offer',
                code: 'ICICI20',
                bank_name: Enums::Bank::ICICI,
                card_types: [Enums::CardType::CREDIT],
                percentage: 20,
                valid_from: Date.today - 7,
                valid_to: Date.today + 7
              })
            ],
            expected_discounts: ['PUMABULK', 'BULKFOOT', 'ICICI20']
          }
        ]
      end
    end
  end
end 