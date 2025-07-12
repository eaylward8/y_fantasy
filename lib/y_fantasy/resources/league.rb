# frozen_string_literal: true

module YFantasy
  # Represents a Yahoo Fantasy League.

  class League < BaseResource
    # --- REQUIRED ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] league_key
    # @return [String] The unique key for this league
    option :league_key

    # @!attribute [r] league_id
    # @return [String] The ID for this league
    option :league_id

    # @!attribute [r] allow_add_to_dl_extra_pos
    # @return [Boolean] Whether the league allows adding extra positions to DL
    option :allow_add_to_dl_extra_pos, Types::Params::Bool

    # @!attribute [r] draft_status
    # @return [String] The status of the draft
    option :draft_status

    # @!attribute [r] edit_key
    # @return [String] The edit key for this league
    option :edit_key

    # @!attribute [r] end_date
    # @return [Date] The end date of the league
    option :end_date, type: Types::Params::Date

    # @!attribute [r] felo_tier
    # @return [String] The Fantasy ELO tier of the league
    option :felo_tier

    # @!attribute [r] game_code
    # @return [String] The game code (e.g. "nfl", "nba")
    option :game_code

    # @!attribute [r] is_cash_league
    # @return [Boolean] Whether this is a cash league
    option :is_cash_league, Types::Params::Bool

    # @!attribute [r] is_pro_league
    # @return [Boolean] Whether this is a pro league
    option :is_pro_league, Types::Params::Bool

    # @!attribute [r] league_type
    # @return [String] The type of league
    option :league_type

    # @!attribute [r] league_update_timestamp
    # @return [Integer] The timestamp of the last league update
    option :league_update_timestamp, Types::Coercible::Integer

    # @!attribute [r] logo_url
    # @return [String] The URL for the league logo
    option :logo_url

    # @!attribute [r] name
    # @return [String] The name of the league
    option :name

    # @!attribute [r] num_teams
    # @return [Integer] The number of teams in the league
    option :num_teams, type: Types::Coercible::Integer

    # @!attribute [r] renew
    # @return [String] Previous league ID in the format "<game_id>_<league_id>"
    # @example "123_111111"
    option :renew

    # @!attribute [r] renewed
    # @return [String] Next league ID in the format "<game_id>_<league_id>"
    # @example "789_222222"
    option :renewed

    # @!attribute [r] scoring_type
    # @return [String] The scoring type of the league
    option :scoring_type

    # @!attribute [r] season
    # @return [String] The season year of the league
    option :season

    # @!attribute [r] start_date
    # @return [Date] The start date of the league
    option :start_date, type: Types::Params::Date

    # @!attribute [r] url
    # @return [String] The URL to the league's Yahoo Fantasy page
    option :url

    # @!attribute [r] weekly_deadline
    # @return [String] The weekly deadline type
    option :weekly_deadline

    # --- OPTIONAL ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] short_invitation_url
    # @return [String, nil] The short URL for invitations to the league
    option :short_invitation_url, optional: true

    # @!attribute [r] current_week
    # @return [Integer, nil] The current week number of the league
    option :current_week, optional: true, type: Types::Coercible::Integer

    # @!attribute [r] start_week
    # @return [Integer, nil] The starting week of the league
    option :start_week, optional: true, type: Types::Coercible::Integer

    # @!attribute [r] end_week
    # @return [Integer, nil] The final week of the league
    option :end_week, optional: true, type: Types::Coercible::Integer

    # @!attribute [r] is_finished
    # @return [Boolean, nil] Whether the league has finished
    option :is_finished, optional: true, type: Types::Params::Bool

    # --- SUBRESOURCES -------------------------------------------------------------------------------------------------

    # @!attribute [r] draft_results
    # @return [Array<DraftResult>, nil] The draft results for the league
    option :draft_results, optional: true, type: array_of(DraftResult)

    # @!attribute [r] players
    # @return [Array<Player>, nil] The players in the league. By default, only 25 players are returned.
    option :players, optional: true, type: array_of(Player)

    # @!attribute [r] scoreboard
    # @return [Scoreboard, nil] The league scoreboard
    option :scoreboard, optional: true, type: instance_of(Scoreboard)

    # @!attribute [r] settings
    # @return [Settings, nil] The league settings
    option :settings, optional: true, type: instance_of(Settings)

    # @!attribute [r] standings
    # @return [Standings, nil] The league standings
    option :standings, optional: true, type: instance_of(Standings)

    # @!attribute [r] teams
    # @return [Array<Team>, nil] The teams in this league
    option :teams, optional: true, type: array_of(Team)

    has_subresource :draft_results, klass: DraftResult
    has_subresource :players, klass: Player
    has_subresource :scoreboard, klass: Scoreboard
    has_subresource :settings, klass: Settings
    has_subresource :standings, klass: Standings
    has_subresource :teams, klass: Team

    # --- INSTANCE METHODS ---------------------------------------------------------------------------------------------

    # Whether the league has started
    # @return [Boolean] Whether the league has started based on the start date
    def started?
      Date.today >= start_date
    end

    # Whether the league has ended
    # @return [Boolean] Whether the league has ended based on finished status or end date
    def ended?
      is_finished || Date.today > end_date
    end

    # Returns the key of the previous league
    # @return [String, nil] The key of the previous league, if any
    def previous_league_key
      renew&.split("_")&.join(".l.")
    end

    # Returns the key of the next/renewed league
    # @return [String, nil] The key of the next/renewed league, if any
    def next_league_key
      renewed&.split("_")&.join(".l.")
    end

    # Gets the scoreboard for a specific week
    # @param week [Integer] The week number to get the scoreboard for
    # @return [Scoreboard] The scoreboard for the specified week
    def scoreboard_for_week(week)
      @scoreboard = self.class.find(league_key, with: :scoreboard, week: week).scoreboard
    end
  end
end
