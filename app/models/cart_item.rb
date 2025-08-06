require_relative 'product'

class CartItem
  include ActiveModel::Model
  
  attr_accessor :product, :quantity, :cart_size

  def initialize(attributes = {})
    super
    validate!
  end

  private

  def validate!
    raise ArgumentError, 'Quantity must be positive' unless quantity.is_a?(Integer) && quantity.positive?
    raise ArgumentError, 'Product is required' unless product.is_a?(Product)
  end
end
