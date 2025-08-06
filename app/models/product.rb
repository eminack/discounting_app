require 'bigdecimal'

class Product
  include ActiveModel::Model
  
  attr_accessor :id, :brand, :brand_tier, :category, :base_price, :current_price

  def initialize(attributes = {})
    super
    self.base_price = BigDecimal(attributes[:base_price].to_s) if attributes[:base_price]
    self.current_price ||= base_price
    validate!
  end

  private

  def validate!
    raise ArgumentError, 'Invalid brand tier' unless Enums::BrandTier.valid?(brand_tier)
  end
end
