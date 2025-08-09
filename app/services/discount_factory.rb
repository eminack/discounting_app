class DiscountFactory
  STRATEGY_MAP = {
    DiscountingApp::Enums::DiscountStrategy::BRAND_PERCENTAGE_DISCOUNT => DiscountStrategies::BrandPercentageDiscountStrategy,
    DiscountingApp::Enums::DiscountStrategy::CATEGORY_PERCENTAGE_DISCOUNT => DiscountStrategies::CategoryPercentageDiscountStrategy,
    DiscountingApp::Enums::DiscountStrategy::BANK_OFFER => DiscountStrategies::BankCardOfferDiscountStrategy,
    DiscountingApp::Enums::DiscountStrategy::VOUCHER_DISCOUNT => DiscountStrategies::VoucherDiscountStrategy
  }

  def self.build(type, attributes)
    strategy_class = STRATEGY_MAP[type.to_sym]
    Discount.create(attributes.slice(:name, :code, :valid_from, :valid_to), strategy_class.new(attributes))
  end
end