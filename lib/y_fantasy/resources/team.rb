# frozen_string_literal: true

module YFantasy
  class Team < BaseResource
    # Required attributes
    option :team_key
    option :team_id, type: Types::Coercible::Integer

    option :has_draft_grade, type: Types::Params::Bool
    option :league_scoring_type
    option :managers, type: array_of(Manager)
    option :name
    option :number_of_moves, type: Types::Coercible::Integer
    option :number_of_trades, type: Types::Coercible::Integer
    option :roster_adds do
      option :coverage_type
      option :coverage_value, type: Types::Coercible::Integer
      option :value, type: Types::Coercible::Integer
    end
    option :team_logos, type: ->(h) { h[:team_logo] }
    option :url

    # Optional attributes
    option :clinched_playoffs, optional: true, type: Types::Params::Bool
    option :division_id, optional: true, type: Types::Coercible::Integer
    option :draft_grade, optional: true
    option :draft_recap_url, optional: true
    option :faab_balance, optional: true, type: Types::Coercible::Integer
    option :waiver_priority, optional: true, type: Types::Coercible::Integer

    # Subresources
    option :draft_results, optional: true, type: array_of(DraftResult)
    option :roster, optional: true, type: instance_of(Roster)
    option :team_standings, optional: true, type: instance_of(Standings)

    # Subresources provided by :team_stats
    option :stats, optional: true, type: instance_of(StatCollection), default: -> {}
    #   option :team_stats, optional: true#, type: instance_of(StatCollection)

    #   option :team_points, optional: true, default: -> {} do
    #     option :coverage_type, optional: true, default: -> {}
    #     option :season, optional: true, default: -> {}
    #     option :total, optional: true, default: -> {}
    #     option :week, optional: true, default: -> {}
    #   end

    #   option :team_projected_points, optional: true, default: -> {} do
    #     option :coverage_type, optional: true, default: -> {}
    #     option :season, optional: true, default: -> {}
    #     option :total, optional: true, default: -> {}
    #     option :week, optional: true, default: -> {}
    #   end

    #   option :team_remaining_games, optional: true, default: -> {} do
    #     option :coverage_type, optional: true, default: -> {}
    #     option :week, optional: true, default: -> {}
    #     option :completed_games, optional: true, default: -> {}
    #     option :live_games, optional: true, default: -> {}
    #     option :remaining_games, optional: true, default: -> {}
    #   end
    # end

    has_subresources :draft_results,
      :roster,
      :team_standings,
      :stats,
      dependent: true
  end
end
