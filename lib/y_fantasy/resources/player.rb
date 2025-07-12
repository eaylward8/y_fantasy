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
    option :headshot
    option :image_url
    option :is_keeper
    option :is_undroppable, type: Types::Params::Bool
    option :name
    option :position_type
    option :uniform_number
    option :url

    # Optional attributes
    option :bye_weeks, optional: true, type: ->(h) { h[:week] }
    option :has_player_notes, optional: true, type: Types::Params::Bool
    option :has_recent_player_notes, optional: true, type: Types::Params::Bool
    option :player_notes_last_timestamp, optional: true, type: Types::Coercible::Integer

    # Subresources
    option :draft_analysis, optional: true, type: instance_of(DraftAnalysis)
    option :ownership_percentage, optional: true, type: instance_of(OwnershipPercentage)
    option :stats, optional: true, type: instance_of(StatCollection)

    has_subresource :draft_analysis, klass: DraftAnalysis
    has_subresource :ownership_percentage, klass: OwnershipPercentage
    has_subresource :stats, klass: StatCollection

    def first_name
      name[:first]
    end

    def last_name
      name[:last]
    end

    def full_name
      name[:full]
    end
  end
end
