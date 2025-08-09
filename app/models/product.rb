require 'bigdecimal'

class Product
  include ActiveModel::Model
  
  attr_accessor :id, :brand, :brand_tier, :category, :price, :current_price

  def initialize(attributes = {})
    super
    self.price = BigDecimal(attributes[:price].to_s) if attributes[:price]
    self.current_price = price
    validate!
  end

  private

  def validate!
    raise ArgumentError, 'Invalid brand tier' unless Enums::BrandTier.valid?(brand_tier)
  end
end
