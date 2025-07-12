# frozen_string_literal: true

module YFantasy
  class Player
    # Represents ownership percentage data for a player in Yahoo Fantasy Sports.
    class OwnershipPercentage < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------

      # @!attribute [r] coverage_type
      # @return [String] the type of coverage (e.g., "week")
      option :coverage_type

      # @!attribute [r] delta
      # @return [Integer] the change in ownership percentage
      option :delta, type: Types::Coercible::Integer

      # @!attribute [r] value
      # @return [Integer] the ownership percentage, given as a whole number
      option :value, type: Types::Coercible::Integer

      # @!attribute [r] week
      # @return [Integer] the week for which ownership percentage is reported
      option :week, type: Types::Coercible::Integer
    end
  end
end
