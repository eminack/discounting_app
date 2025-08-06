require 'bigdecimal'

class DiscountedPrice
  include ActiveModel::Model
  
  attr_accessor :original_price, :final_price, :applied_discounts, :messages

  def initialize(attributes = {})
    super
    self.original_price = BigDecimal(attributes[:original_price].to_s) if attributes[:original_price]
    self.final_price ||= original_price
    self.applied_discounts ||= {}
    self.messages ||= []
    validate!
  end

  private

  def validate!
    raise ArgumentError, 'Original price must be positive' unless original_price.positive?
    raise ArgumentError, 'Final price must be positive' unless final_price.positive?
    raise ArgumentError, 'Final price cannot be greater than original price' unless final_price <= original_price
  end
end
