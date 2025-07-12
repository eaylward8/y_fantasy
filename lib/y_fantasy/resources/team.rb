# frozen_string_literal: true

module YFantasy
  # Represents a fantasy team in a Yahoo Fantasy Sports league
  class Team < BaseResource
    # --- REQUIRED ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] team_key
    # @return [String] the unique key for this team
    option :team_key

    # @!attribute [r] team_id
    # @return [Integer] the ID for this team
    option :team_id, type: Types::Coercible::Integer

    # @!attribute [r] has_draft_grade
    # @return [Boolean] whether this team has a draft grade
    option :has_draft_grade, type: Types::Params::Bool

    # @!attribute [r] league_scoring_type
    # @return [String] the scoring type of the league (e.g. "head", "point")
    option :league_scoring_type

    # @!attribute [r] managers
    # @return [Array<Manager>] Array of team managers
    option :managers, type: array_of(Manager)

    # @!attribute [r] name
    # @return [String] the name of the team
    option :name

    # @!attribute [r] number_of_moves
    # @return [Integer] the number of roster moves made by this team
    option :number_of_moves, type: Types::Coercible::Integer

    # @!attribute [r] number_of_trades
    # @return [Integer] the number of trades made by this team
    option :number_of_trades, type: Types::Coercible::Integer

    # @!attribute [r] roster_adds
    # @return [String] the roster adds information for this team
    option :roster_adds

    # @!attribute [r] team_logos
    # @return [Hash] the team logo information
    option :team_logos, type: ->(h) { h[:team_logo] }

    # @!attribute [r] url
    # @return [String] the URL to the team's Yahoo Fantasy page
    option :url

    # --- OPTIONAL ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] clinched_playoffs
    # @return [Boolean, nil] whether this team has clinched a playoff spot
    option :clinched_playoffs, optional: true, type: Types::Params::Bool

    # @!attribute [r] division_id
    # @return [Integer, nil] the ID of the division this team belongs to
    option :division_id, optional: true, type: Types::Coercible::Integer

    # @!attribute [r] draft_grade
    # @return [String, nil] the grade assigned to this team's draft
    option :draft_grade, optional: true

    # @!attribute [r] draft_recap_url
    # @return [String, nil] the URL to this team's draft recap
    option :draft_recap_url, optional: true

    # @!attribute [r] faab_balance
    # @return [Integer, nil] the remaining Free Agent Acquisition Budget (FAAB) for this team
    option :faab_balance, optional: true, type: Types::Coercible::Integer

    # @!attribute [r] waiver_priority
    # @return [Integer, nil] This team's waiver priority
    option :waiver_priority, optional: true, type: Types::Coercible::Integer

    # @!attribute [r] league_key
    # @return [String, nil] the key of the league this team belongs to
    option :league_key, optional: true

    # @!attribute [r] league
    # @return [League, nil] the league this team belongs to
    option :league, optional: true

    # --- SUBRESOURCES -------------------------------------------------------------------------------------------------

    # @!attribute [r] draft_results
    # @return [Array<DraftResult>, nil] the draft results for this team
    option :draft_results, optional: true, type: array_of(DraftResult)

    # @!attribute [r] matchups
    # @return [Array<Matchup>] the matchups for this team
    option :matchups, optional: true, type: array_of(Matchup), default: -> { [] }

    # @!attribute [r] roster
    # @return [Roster, nil] the roster for this team
    option :roster, optional: true, type: instance_of(Roster)

    # @!attribute [r] stats
    # @return [StatCollection, nil] the stat collection for this team
    option :stats, optional: true, type: instance_of(StatCollection), default: -> {}

    # @!attribute [r] team_standings
    # @return [Standings, nil] the standings for this team
    option :team_standings, optional: true, type: instance_of(Standings)

    has_subresource :draft_results, klass: DraftResult
    has_subresource :matchups, klass: Matchup
    has_subresource :roster, klass: Roster
    has_subresource :stats, klass: StatCollection
    has_subresource :team_standings, klass: Standings

    def_delegators :team_standings, :rank, :playoff_seed, :wins, :losses, :ties, :points_for, :points_against

    # --- INSTANCE METHODS ---------------------------------------------------------------------------------------------

    # Returns the primary manager of the team
    # @return [Manager] the primary manager (non-comanager) of the team
    def manager
      managers.find { |manager| !manager.is_comanager }
    end

    # Returns a hash of simplified standings information for the team
    # @return [Hash] a hash containing key standings information
    def simple_standings
      {
        team_key: team_key,
        name: name,
        rank: rank,
        playoff_seed: playoff_seed,
        wins: wins,
        losses: losses,
        ties: ties,
        points_for: points_for,
        points_against: points_against
      }
    end

    # Returns the league key for this team
    # @return [String] the league key
    def league_key
      @league_key ||= team_key.sub(/\.t\.\d+/, "")
    end

    # Returns the league this team belongs to
    # @return [League] the league object
    def league
      @league ||= League.find(league_key)
    end

    # Gets the matchups for this team for a specific week
    # @param week [Integer] the week number to get matchups for
    # @return [Array<Matchup>] the matchups for the specified week
    def matchups_for_week(week)
      @matchups = self.class.find(team_key, with: :matchups, week: week).matchups
    end

    # Gets the roster for this team for a specific week
    # @param week [Integer] the week number to get the roster for
    # @param player_stats [Boolean] Whether to include player stats
    # @return [Roster] the roster for the specified week
    def roster_for_week(week, player_stats: false)
      with = player_stats ? {roster: {players: :stats}} : :roster
      @roster = self.class.find(team_key, with: with, week: week).roster
    end

    # Gets the stats for this team for a specific week
    # @param week [Integer] the week number to get stats for
    # @return [StatCollection] the stats for the specified week
    def stats_for_week(week)
      @stats = self.class.find(team_key, with: :stats, week: week).stats
    end
  end
end
