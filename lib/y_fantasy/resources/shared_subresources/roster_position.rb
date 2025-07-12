# frozen_string_literal: true

module YFantasy
  # Reprsents a Yahoo Fantasy roster position
  class RosterPosition < BaseSubresource
    # --- REQUIRED ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] position
    # @return [String] the position name (e.g., "QB")
    option :position

    # --- OPTIONAL ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] abbreviation
    # @return [String] the position abbreviation
    option :abbreviation, optional: true

    # @!attribute [r] display_name
    # @return [String] the position display name
    option :display_name, optional: true

    # @!attribute [r] position_type
    # @return [String] the position type (e.g., "O", "DT", "K", "BN")
    option :position_type, optional: true

    # @!attribute [r] count
    # @return [Integer] the number of this position type allowed on a roster
    option :count, optional: true, type: Types::Coercible::Integer

    # @!attribute [r] is_bench
    # @return [Boolean] whether this position is a bench position
    option :is_bench, optional: true, type: Types::Params::Bool

    # @!attribute [r] is_starting_position
    # @return [Boolean] whether this position is a starting position
    option :is_starting_position, optional: true, type: Types::Params::Bool
  end
end
