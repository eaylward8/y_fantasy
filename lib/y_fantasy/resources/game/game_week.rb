# frozen_string_literal: true

module YFantasy
  class Game
    # Represents a week in a fantasy game schedule
    class GameWeek < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------

      # @!attribute [r] week
      # @return [Integer] the week number
      option :week, type: Types::Coercible::Integer

      # @!attribute [r] display_name
      # @return [String] the week number as a string
      option :display_name

      # @!attribute [r] start
      # @return [Date] week start date
      option :start, type: Types::Params::Date

      # @!attribute [r] end
      # @return [Date] week end date
      option :end, type: Types::Params::Date
    end
  end
end
