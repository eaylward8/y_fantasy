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
    option :waiver_priority, type: Types::Coercible::Integer

    # Optional attributes
    option :clinched_playoffs, optional: true, type: Types::Params::Bool
    option :division_id, optional: true, type: Types::Coercible::Integer
    option :draft_grade, optional: true
    option :draft_recap_url, optional: true
    option :faab_balance, optional: true, type: Types::Coercible::Integer
    option :team_points, optional: true do
      option :coverage_type
      option :season, optional: true, type: Types::Coercible::Integer
      option :total, type: Types::Coercible::Float
      option :week, optional: true, type: Types::Coercible::Integer
    end
    option :team_projected_points, optional: true do
      option :coverage_type
      option :season, optional: true, type: Types::Coercible::Integer
      option :total, type: Types::Coercible::Float
      option :week, optional: true, type: Types::Coercible::Integer
    end

    # Subresources
    option :draft_results, optional: true, type: array_of(DraftResult)
    option :roster, optional: true, type: instance_of(Roster)
    option :standings, optional: true, type: instance_of(Standings)

    has_subresources :draft_results,
      :roster,
      :standings,
      :stats,
      dependent: true
  end
end
