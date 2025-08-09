class Context
  include ActiveModel::Model

  attr_accessor :cart, :customer, :payment_info

  validates :cart, :customer, presence: true
end