# frozen_string_literal: true

module YFantasy
  class ResourceFinder
    PRIMARY = {
      games: Game,
      leagues: League,
      players: Player,
      teams: Team
    }

    DEPENDENT = {
      draft_analysis: Player::DraftAnalysis,
      draft_results: DraftResult,
      game_weeks: Game::GameWeek,
      matchups: Matchup,
      ownership_percentage: Player::OwnershipPercentage,
      position_types: Game::PositionType,
      roster: Team::Roster,
      roster_positions: RosterPosition,
      scoreboard: League::Scoreboard,
      settings: League::Settings,
      standings: League::Standings,
      stats: Stat,
      stat_categories: StatCategory,
      stat_modifiers: StatModifier,
      team_standings: Team::Standings,
      team_stats: Stat
    }

    # just an idea:
    # MAP = {
    #   game: {
    #     game: Game,
    #     game_weeks: Game::GameWeek,
    #     position_types: Game::PositionType,
    #     roster_positions: RosterPosition,
    #     stat_categories: StatCategory
    #   },
    #   league: {
    #     league: League,
    #     draft_results: DraftResult,
    #     scoreboard: League::Scoreboard,
    #     settings: League::Settings,
    #     standings: League::Standings
    #   },
    #   player: {
    #     player: Player,
    #     ownership_percentage: Player::OwnershipPercentage,
    #     stats: Player::Stat
    #   },
    #   team: {
    #     team: Team,
    #     draft_results: DraftResult,
    #     roster: Team::Roster,
    #     standings: Team::Standings,
    #     stats: Team::Stat
    #   }
    # }

    def self.find_primary(collection_name)
      PRIMARY.fetch(collection_name.to_sym)
    end

    def self.find_dependent(collection_name)
      DEPENDENT.fetch(collection_name.to_sym)
    end
  end
end

# {
#   teams: {
#     players: {
#       draft_analysis: nil,
#     },
#     stats: nil,

#   }
# }