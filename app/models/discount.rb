class Discount
  include ActiveModel::Model

  attr_accessor :valid_from, :valid_to, :strategy, :name, :code

  validates :strategy, :name, presence: true

  # this can only be initialized by the DiscountFactory
  class << self
    def create(attributes, strategy)
      new(attributes.merge(strategy: strategy))
    end
  end

  def active?(date = Date.today)
    (valid_from.nil? || valid_from <= date) &&
      (valid_to.nil? || valid_to >= date)
  end

  def apply(context)
    return unless active?
    strategy.calculator_class.new.calculate_discount(context, self)
  end

  def validate_discount_code(context)
    strategy.valid_for_context?(context)
  end
end