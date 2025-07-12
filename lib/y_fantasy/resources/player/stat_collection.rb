# frozen_string_literal: true

module YFantasy
  class Player
    # A collection of stats for a player, for a given time period (e.g., season, week).
    class StatCollection < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------

      # @!attribute [r] coverage_type
      # @return [String] the type of coverage (e.g., "week", "season")
      option :coverage_type

      # @!attribute [r] standard_stats
      # @return [Array<Stat>] standard stats for this player
      option :standard_stats, type: array_of(Stat)

      # --- OPTIONAL ATTRIBUTES ----------------------------------------------------------------------------------------

      # @!attribute [r] advanced_stats
      # @return [Array<Stat>] advanced stats for this player
      option :advanced_stats, optional: true, type: array_of(Stat)

      # @!attribute [r] season
      # @return [Integer] the season for which stats are reported
      option :season, optional: true, type: Types::Coercible::Integer

      # @!attribute [r] week
      # @return [Integer] the week for which stats are reported (nil if coverage_type is "season")
      option :week, optional: true, type: Types::Coercible::Integer
    end
  end
end
