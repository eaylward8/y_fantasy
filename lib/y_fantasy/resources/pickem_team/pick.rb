# frozen_string_literal: true

module YFantasy
  class PickemTeam
    # Represents a single team pick in a pickem fantasy contest
    class Pick < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------

      # @!attribute [r] team
      # @return [String] the Yahoo team key (e.g., "nfl.t.1")
      option :team

      # @!attribute [r] result
      # @return [Object] the result of the pick ("correct" or "strike")
      option :result

      # @!attribute [r] locked
      # @return [Boolean] whether the pick is locked and cannot be changed
      option :locked, type: Types::Params::Bool

      # :nocov:

      # @return [Hash] Team details (city, team name, abbreviation) for the pick
      def team_details
        Ref::Nfl.team(team)
      end

      # :nocov:
    end
  end
end
