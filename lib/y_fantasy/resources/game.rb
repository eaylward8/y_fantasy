# frozen_string_literal: true

module YFantasy
  # Represents a Yahoo Fantasy Game (e.g. NFL, NBA, MLB).
  # A game is the top-level sports resource and contains leagues, which contain teams.
  #
  # @example Get NFL game information with game weeks
  #   games = YFantasy::Game.find_all_by_code('nfl', with: [:game_weeks])
  #
  # @see https://developer.yahoo.com/fantasysports/guide/#game-resource
  class Game < BaseResource
    # TODO: make constant of all valid yahoo game codes (nfl, nba, nfls, etc)

    # --- REQUIRED ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] game_key
    # @return [String] The unique key for this game
    option :game_key

    # @!attribute [r] game_id
    # @return [String] The ID for this game (for Game resource, this is the same as game_key)
    option :game_id

    # @!attribute [r] name
    # @return [String] The name of the game (eg. "Football", "Baseball")
    option :name

    # @!attribute [r] code
    # @return [String] The general code for this game (eg. "nfl", "nba")
    option :code

    # @!attribute [r] type
    # @return [String] The type of game (eg. "full")
    option :type

    # @!attribute [r] url
    # @return [String] The URL to the game's home page
    option :url

    # @!attribute [r] season
    # @return [Integer] The year of the season
    option :season, type: Types::Coercible::Integer

    # @!attribute [r] is_registration_over
    # @return [Boolean] Whether registration for this game is over
    option :is_registration_over, type: Types::Params::Bool

    # @!attribute [r] is_game_over
    # @return [Boolean] Whether this game's season is over
    option :is_game_over, type: Types::Params::Bool

    # @!attribute [r] is_offseason
    # @return [Boolean] Whether this game is in the offseason
    option :is_offseason, type: Types::Params::Bool

    # --- OPTIONAL ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] current_week
    # @return [Integer, nil] The current week number of the game
    option :current_week, optional: true

    # @!attribute [r] is_contest_reg_active
    # @return [Boolean, nil] Whether contest registration is active
    option :is_contest_reg_active, optional: true, type: Types::Params::Bool

    # @!attribute [r] is_contest_over
    # @return [Boolean, nil] Whether the contest is over
    option :is_contest_over, optional: true, type: Types::Params::Bool

    # @!attribute [r] has_schedule
    # @return [Boolean, nil] Whether this game has a schedule
    option :has_schedule, optional: true, type: Types::Params::Bool

    # --- SUBRESOURCES -------------------------------------------------------------------------------------------------

    # @!attribute [r] game_weeks
    # @return [Array<GameWeek>, nil] Array of game weeks for this game
    option :game_weeks, optional: true, type: array_of(GameWeek)

    # @!attribute [r] position_types
    # @return [Array<PositionType>, nil] Array of position types for this game
    option :position_types, optional: true, type: array_of(PositionType)

    # @!attribute [r] roster_positions
    # @return [Array<RosterPosition>, nil] Array of roster positions for this game
    option :roster_positions, optional: true, type: array_of(RosterPosition)

    # @!attribute [r] stat_categories
    # @return [Array<StatCategory>, nil] Array of stat categories for this game
    option :stat_categories, optional: true, type: array_of(StatCategory)

    # @!attribute [r] groups
    # @return [Array<Group>, nil] Array of groups for this game (e.g. NFL Survival)
    option :groups, optional: true, type: array_of(Group)

    # @!attribute [r] leagues
    # @return [Array<League>, nil] Array of leagues belonging to this game
    option :leagues, optional: true, type: array_of(League)

    # Define subresource associations
    has_subresource :game_weeks, klass: GameWeek
    has_subresource :position_types, klass: PositionType
    has_subresource :roster_positions, klass: RosterPosition
    has_subresource :stat_categories, klass: StatCategory

    has_subresource :groups, klass: Group # NFL Survival
    has_subresource :leagues, klass: League

    # --- CLASS METHODS ------------------------------------------------------------------------------------------------

    # Finds all games by their code(s)
    #
    # @param codes [String, Symbol, Array<String>, Array<Symbol>] The code(s) of the game(s) to find (e.g. 'nfl', 'nba')
    # @param with [Symbol, Array<Symbol>] Optional subresources to include
    # @param options [Hash] Additional options to pass to the API client
    # @return [Array<Game>] Array of games matching the given code(s)
    # @example Find all NFL games with game weeks
    #   YFantasy::Game.find_all_by_code('nfl', with: :game_weeks)
    # @example Find all NFL and NBA games
    #   YFantasy::Game.find_all_by_code(['nfl', 'nba'])
    def self.find_all_by_code(codes, with: [], **options)
      subresources = Transformations::T.wrap_in_array(with)
      SubresourceValidator.validate!(self, subresources)
      data = YFantasy::Api::Client.get(:games, game_codes: codes, subresources: subresources, **options)
      Transformations::CollectionTransformer.new(:games).call(data)
    end

    # Retrieves leagues associated with this game
    #
    # @param league_keys [Array<String>] Optional specific league keys to retrieve
    # @return [Array<League>] Array of leagues
    # def leagues(league_keys = [])
    #   @leagues ||= League.find_all(Array(league_keys))
    # end
  end
end
