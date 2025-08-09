class CustomerProfile
  include ActiveModel::Model
  
  attr_accessor :id, :tier

  def initialize(attributes = {})
    super
    validate!
  end

  private

  def validate!
    raise ArgumentError, 'Invalid customer tier' unless Enums::CustomerTier.valid?(tier)
  end
end
