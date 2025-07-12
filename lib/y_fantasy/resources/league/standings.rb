# frozen_string_literal: true

module YFantasy
  class League
    # Standings for a league
    class Standings < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------
      option :teams, array_of(Team)

      # --- INSTANCE METHODS -------------------------------------------------------------------------------------------

      # Returns an array of team hashes, sorted by rank.
      # @return [Array<Hash>]
      def final
        teams.map(&:simple_standings).sort_by { |h| h[:rank] }
      end

      # Returns an array of team hashes, sorted by wins and points for.
      # @return [Array<Hash>]
      def regular_season
        teams.map(&:simple_standings).sort_by { |h| [-h[:wins], -h[:points_for]] }
      end
    end
  end
end
