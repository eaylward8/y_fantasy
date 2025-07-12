# frozen_string_literal: true

module YFantasy
  class Matchup < DependentSubresource
    # Required attributes
    option :is_consolation, type: Types::Params::Bool
    option :is_playoffs, type: Types::Params::Bool
    option :status
    option :week, type: Types::Coercible::Integer
    option :week_end, type: Types::Params::Date
    option :week_start, type: Types::Params::Date

    # Optional attributes
    option :is_matchup_recap_available, optional: true, type: Types::Params::Bool
    option :is_tied, optional: true, type: Types::Params::Bool
    option :stat_winners, optional: true, type: array_of(StatWinner)
    option :winner_team_key, optional: true

    # Subresources
    option :teams, type: array_of(Team)

    def winning_team
      return if is_tied

      teams.find { |team| team.team_key == winner_team_key }
    end

    def losing_team
      return if is_tied

      teams.find { |team| team.team_key != winner_team_key }
    end

    def scores
      teams.map do |team|
        {
          team_key: team.team_key,
          team_name: team.name,
          total: team.stats.team_points.total,
          proj_total: team.stats.team_projected_points.total
        }
      end
    end
  end
end
