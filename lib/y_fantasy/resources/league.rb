# frozen_string_literal: true

module YFantasy
  class League < BaseResource
    # Required attributes
    option :league_key
    option :league_id
    option :name
    option :url
    option :logo_url
    option :draft_status
    option :num_teams, type: Types::Coercible::Integer
    option :edit_key
    option :weekly_deadline
    option :league_update_timestamp, Types::Coercible::Integer
    option :scoring_type
    option :league_type
    option :renew
    option :renewed
    option :felo_tier
    option :allow_add_to_dl_extra_pos, Types::Params::Bool
    option :is_pro_league, Types::Params::Bool
    option :is_cash_league, Types::Params::Bool
    option :start_date, type: Types::Params::Date
    option :end_date, type: Types::Params::Date
    option :game_code
    option :season

    # Optional attributes
    option :short_invitation_url, optional: true
    option :current_week, optional: true, type: Types::Coercible::Integer
    option :start_week, optional: true, type: Types::Coercible::Integer
    option :end_week, optional: true, type: Types::Coercible::Integer
    option :is_finished, optional: true, type: Types::Params::Bool

    # Subresources
    option :draft_results, optional: true, type: array_of(DraftResult)
    option :scoreboard, optional: true, type: instance_of(Scoreboard)
    option :settings, optional: true, type: instance_of(Settings)
    option :standings, optional: true, type: instance_of(Standings)
    option :teams, optional: true, type: array_of(Team)

    has_subresources :teams
    has_subresources :draft_results, :scoreboard, :settings, :standings, dependent: true
  end
end
