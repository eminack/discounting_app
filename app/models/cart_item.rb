require_relative 'product'

class CartItem
  include ActiveModel::Model
  
  attr_accessor :product, :quantity

  def initialize(attributes = {})
    super
    validate!
  end

  ## Notes:
  ## - Not tracking total price at cart item level since:
  ##   - Cannot simply multiply current price by quantity
  ##   - Discounts may apply to only some units (e.g. 2 out of 100)
  ## 
  ## - Potential solution:
  ##   - Create separate SKU entity representing single product unit
  ##   - CartItem would contain multiple SKUs
  ##   - Each SKU could track its own discounted price

  private

  def validate!
    raise ArgumentError, 'Quantity must be positive' unless quantity.is_a?(Integer) && quantity.positive?
    raise ArgumentError, 'Product is required' unless product.is_a?(Product)
  end
end
