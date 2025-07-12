# frozen_string_literal: true

module YFantasy
  class League
    class Standings < DependentSubresource
      # Required attributes
      option :teams, array_of(Team)

      def final
        teams.map(&:simple_standings).sort_by { |h| h[:rank] }
      end

      def regular_season
        teams.map(&:simple_standings).sort_by { |h| [-h[:wins], -h[:points_for]] }
      end
    end
  end
end
