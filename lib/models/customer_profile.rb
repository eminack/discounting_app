require_relative 'enums'

module DiscountingApp
  module Models
    # CustomerProfile data class
    CustomerProfile = Struct.new(:id, :tier, keyword_init: true) do
      def initialize(*)
        super
        validate!
      end

      private

      def validate!
        raise ArgumentError, 'Invalid customer tier' unless Enums::CustomerTier.valid?(tier)
      end
    end
  end
end
