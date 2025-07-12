# frozen_string_literal: true

module YFantasy
  class Settings < DependentSubresource
    # Required attributes
    option :cant_cut_list
    option :draft_time, type: Types::Coercible::Integer
    option :draft_together, type: Types::Params::Bool
    option :draft_type
    option :is_auction_draft, type: Types::Params::Bool
    option :max_teams, type: Types::Coercible::Integer
    option :player_pool
    option :post_draft_players
    option :scoring_type
    option :trade_end_date, type: Types::Params::Date
    option :trade_ratify_type
    option :trade_reject_time, type: Types::Coercible::Integer
    option :uses_faab, type: Types::Params::Bool
    option :uses_playoff, type: Types::Params::Bool
    option :waiver_rule
    option :waiver_time, type: Types::Coercible::Integer
    option :waiver_type

    # Optional attributes
    option :divisions, optional: true, type: ->(h) { h[:division] }
    option :draft_pick_time, optional: true, type: Types::Coercible::Integer
    option :has_multiweek_championship, optional: true, type: Types::Params::Bool
    option :has_playoff_consolation_games, optional: true, type: Types::Params::Bool
    option :max_games_played, optional: true, type: Types::Coercible::Integer
    option :max_innings_pitched, optional: true, type: Types::Coercible::Integer
    option :max_weekly_adds, optional: true, type: Types::Coercible::Integer
    option :num_playoff_consolation_teams, optional: true, type: Types::Coercible::Integer
    option :num_playoff_teams, optional: true, type: Types::Coercible::Integer
    option :pickem_enabled, optional: true, type: Types::Params::Bool
    option :playoff_start_week, optional: true, type: Types::Coercible::Integer
    option :roster_import_deadline, optional: true, type: Types::Params::Date
    option :season_type, optional: true
    option :uses_fractional_points, optional: true, type: Types::Params::Bool
    option :uses_lock_eliminated_teams, optional: true, type: Types::Params::Bool
    option :uses_negative_points, optional: true, type: Types::Params::Bool
    option :uses_playoff_reseeding, optional: true, type: Types::Params::Bool
    option :uses_roster_import, optional: true, type: Types::Params::Bool
    option :waiver_days, optional: true, type: ->(h) { h.values.flatten }

    # Subresources
    option :roster_positions, optional: true, type: array_of(RosterPosition)
    option :stat_categories, optional: true, type: array_of(StatCategory)
    option :stat_modifiers, optional: true, type: array_of(StatModifier)

    has_subresources :roster_positions, :stat_categories, :stat_modifiers, dependent: true
  end
end
