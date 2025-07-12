# frozen_string_literal: true

module YFantasy
  class Game < BaseResource
    # Required attributes
    option :game_key
    option :game_id
    option :name
    option :code
    option :type
    option :url
    option :season
    option :is_registration_over, type: Types::Params::Bool
    option :is_game_over, type: Types::Params::Bool
    option :is_offseason, type: Types::Params::Bool

    # Optional attributes
    option :current_week, optional: true
    option :is_contest_reg_active, optional: true, type: Types::Params::Bool
    option :is_contest_over, optional: true, type: Types::Params::Bool
    option :has_schedule, optional: true, type: Types::Params::Bool

    # Subresources
    option :game_weeks, optional: true, type: array_of(GameWeek)
    option :position_types, optional: true, type: array_of(PositionType)
    option :roster_positions, optional: true, type: array_of(RosterPosition)
    option :stat_categories, optional: true, type: array_of(StatCategory)

    has_subresource :game_weeks, klass: GameWeek
    has_subresource :position_types, klass: PositionType
    has_subresource :roster_positions, klass: RosterPosition
    has_subresource :stat_categories, klass: StatCategory
  end
end
