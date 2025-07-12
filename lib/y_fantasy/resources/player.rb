# frozen_string_literal: true

module YFantasy
  # Represents a Yahoo Fantasy Player
  class Player < BaseResource
    # --- REQUIRED ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] player_key
    # @return [String] the unique key for this player, within a Game
    option :player_key

    # @!attribute [r] player_id
    # @return [Integer] the ID for this player
    option :player_id, type: Types::Coercible::Integer

    # @!attribute [r] display_position
    # @return [String] the display position of the player
    # @note When a player has more than one position, this will be a comma-separated string of positions
    option :display_position

    # @!attribute [r] editorial_player_key
    # @return [String] the editorial key for this player
    option :editorial_player_key

    # @!attribute [r] editorial_team_abbr
    # @return [String] the abbreviation of the player's real-life team
    option :editorial_team_abbr

    # @!attribute [r] editorial_team_full_name
    # @return [String] the full name of the player's real-life team
    option :editorial_team_full_name

    # @!attribute [r] editorial_team_key
    # @return [String] the key of the player's real-life team
    option :editorial_team_key

    # @!attribute [r] editorial_team_url
    # @return [String] the URL to the player's real-life team page
    option :editorial_team_url

    # @!attribute [r] eligible_positions
    # @return [String, Array<String>] the eligible positions for this player (e.g. "QB", ["RB", "WR"])
    option :eligible_positions, type: ->(h) { h[:position] }

    # @!attribute [r] headshot
    # @return [Hash] hash containing headshot information (size, url)
    option :headshot

    # @!attribute [r] image_url
    # @return [String] the player's image URL
    option :image_url

    # @!attribute [r] is_keeper
    # @return [Hash] A hash containing the player's keeper status and cost
    option :is_keeper

    # @!attribute [r] is_undroppable
    # @return [Boolean] whether this player is undroppable
    option :is_undroppable, type: Types::Params::Bool

    # @!attribute [r] name
    # @return [Hash] hash containing the player's name (first, last, full, ascii_first, ascii_last)
    option :name

    # @!attribute [r] position_type
    # @return [String] the type of position (e.g. "O" for offense)
    option :position_type

    # @!attribute [r] uniform_number
    # @return [String] the player's uniform number
    option :uniform_number

    # @!attribute [r] url
    # @return [String] the URL to the player's Yahoo Fantasy page
    option :url

    # --- OPTIONAL ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] bye_weeks
    # @return [Array<String>, nil] the bye weeks for this player
    option :bye_weeks, optional: true, type: ->(h) { h[:week] }

    # @!attribute [r] has_player_notes
    # @return [Boolean, nil] whether this player has notes
    option :has_player_notes, optional: true, type: Types::Params::Bool

    # @!attribute [r] has_recent_player_notes
    # @return [Boolean, nil] whether this player has recent notes
    option :has_recent_player_notes, optional: true, type: Types::Params::Bool

    # @!attribute [r] player_notes_last_timestamp
    # @return [Integer, nil] the timestamp of the last player note
    option :player_notes_last_timestamp, optional: true, type: Types::Coercible::Integer

    # @!attribute [r] player_points
    # Hash containing details about the player's fantasy points. Includes: coverage_type, total, week.
    # @note Only available when requesting a player within a team's roster
    # @return [Hash, nil] the player's fantasy points information
    option :player_points, optional: true do
      option :coverage_type
      option :total, type: Types::Coercible::Float
      option :week, optional: true, type: Types::Coercible::Integer
    end

    # @!attribute [r] selected_position
    # Hash containing details about the player's selected position. Includes: coverage_type, is_flex, positition, week.
    # @note Only available when requesting a player within a team's roster
    # @return [Hash, nil] the player's selected position information
    option :selected_position, optional: true do
      option :coverage_type
      option :is_flex, optional: true, type: Types::Params::Bool
      option :position
      option :week, optional: true, type: Types::Coercible::Integer
    end

    # --- SUBRESOURCES -------------------------------------------------------------------------------------------------

    # @!attribute [r] draft_analysis
    # @return [DraftAnalysis, nil] the draft analysis for this player
    option :draft_analysis, optional: true, type: instance_of(DraftAnalysis)

    # @!attribute [r] ownership_percentage
    # @return [OwnershipPercentage, nil] the ownership percentage information for this player
    option :ownership_percentage, optional: true, type: instance_of(OwnershipPercentage)

    # @!attribute [r] stats
    # @return [StatCollection, nil] the stat collection for this player
    option :stats, optional: true, type: instance_of(StatCollection)

    has_subresource :draft_analysis, klass: DraftAnalysis
    has_subresource :ownership_percentage, klass: OwnershipPercentage
    has_subresource :stats, klass: StatCollection

    # --- INSTANCE METHODS ---------------------------------------------------------------------------------------------

    # :nocov:

    # Returns the player's first name
    # @return [String] the player's first name
    def first_name
      name[:first]
    end

    # Returns the player's last name
    # @return [String] the player's last name
    def last_name
      name[:last]
    end

    # Returns the player's full name
    # @return [String] the player's full name
    def full_name
      name[:full]
    end
    # :nocov:
  end
end
