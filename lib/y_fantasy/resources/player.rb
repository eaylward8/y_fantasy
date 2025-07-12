# frozen_string_literal: true

module YFantasy
  class Player < BaseResource
    # Required attributes
    option :player_key
    option :player_id, type: Types::Coercible::Integer

    option :display_position
    option :editorial_player_key
    option :editorial_team_abbr
    option :editorial_team_full_name
    option :editorial_team_key
    option :editorial_team_url
    option :eligible_positions, type: ->(h) { h[:position] }
    option :has_player_notes, type: Types::Params::Bool
    option :headshot
    option :image_url
    option :is_keeper
    option :is_undroppable, type: Types::Params::Bool
    option :name
    option :player_notes_last_timestamp, type: Types::Coercible::Integer
    option :position_type
    option :uniform_number
    option :url

    # Optional attributes
    option :bye_weeks, optional: true
    option :has_recent_player_notes, optional: true, type: Types::Params::Bool

    # Subresources

    # has_subresources :draft_results,
    #   :roster,
    #   :standings,
    #   dependent: true
  end
end
