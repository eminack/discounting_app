require_relative 'product'

class Cart
  include ActiveModel::Model
  
  attr_accessor :cart_items

  def initialize(attributes = {})
    super
    validate!
  end

  def add_item(item)
    cart_items << item
  end

  def remove_item(item)
    cart_items.delete(item)
  end

  private

  def validate!
    raise ArgumentError, 'Cart items must be an array' unless cart_items.is_a?(Array)
    raise ArgumentError, 'Cart items must be an array of CartItem' unless cart_items.all? { |item| item.is_a?(CartItem) }
  end
end
