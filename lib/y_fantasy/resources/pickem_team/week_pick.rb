# frozen_string_literal: true

module YFantasy
  class PickemTeam
    # Represents a single week of picks for a team in a Yahoo Fantasy NFL Survival Group.
    # There may be multiple picks per week.
    class WeekPick < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------

      # @!attribute [r] week
      # @return [Integer] the week number
      option :week, type: Types::Coercible::Integer

      # @!attribute [r] picks_completed
      # @return [Integer] the number of picks completed for this week
      option :picks_completed, type: Types::Coercible::Integer

      # @!attribute [r] picks
      # @return [Array<Pick>] the picks made for this week
      option :picks, type: array_of(Pick)

      # @return [Array<Hash>] team details for each pick
      def pick_details
        picks.compact.map(&:team_details)
      end
    end
  end
end
