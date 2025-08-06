require_relative 'enums'

module DiscountingApp
  module Models
    class CustomerProfile
      attr_reader :id, :tier, :eligible_discounts

      # Initialize a new CustomerProfile
      # @param id [Integer] Customer ID
      # @param tier [String] Customer tier (platinum, gold, silver, regular)
      # @param eligible_discounts [Array<String>] List of discount codes the customer is eligible for
      def initialize(id:, tier:, eligible_discounts: [])
        @id = id
        validate_tier!(tier)
        @tier = tier.downcase
        @eligible_discounts = eligible_discounts
      end

      # Check if customer is eligible for a specific discount code
      # @param code [String] Discount code to check
      # @return [Boolean]
      def eligible_for_discount?(code)
        eligible_discounts.include?(code)
      end

      # Check if customer is in a specific tier or higher
      # @param required_tier [String] Minimum tier required
      # @return [Boolean]
      def meets_tier_requirement?(required_tier)
        tier_ranks = {
          Enums::CustomerTier::PLATINUM => 4,
          Enums::CustomerTier::GOLD => 3,
          Enums::CustomerTier::SILVER => 2,
          Enums::CustomerTier::REGULAR => 1
        }

        current_rank = tier_ranks[tier]
        required_rank = tier_ranks[required_tier.downcase]

        return false unless current_rank && required_rank

        current_rank >= required_rank
      end

      private

      def validate_tier!(tier)
        return if Enums::CustomerTier.valid?(tier)

        raise ArgumentError, "Invalid customer tier: #{tier}. Must be one of: #{Enums::CustomerTier.all.join(', ')}"
      end
    end
  end
end
