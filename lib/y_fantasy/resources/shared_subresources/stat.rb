# frozen_string_literal: true

module YFantasy
  # Represents
  class Stat < BaseSubresource
    # --- REQUIRED ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] stat_id
    # @return [Integer] the Yahoo stat ID
    option :stat_id, type: Types::Coercible::Integer

    # @!attribute [r] value
    # @return [String] the value for this stat
    option :value
  end
end
