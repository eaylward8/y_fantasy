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
      draft_results: DraftResult,
      game_weeks: Game::GameWeek,
      matchups: Matchup,
      position_types: Game::PositionType,
      roster: Team::Roster,
      roster_positions: RosterPosition,
      scoreboard: League::Scoreboard,
      settings: League::Settings,
      standings: League::Standings,
      stats: Player::Stat,
      stat_categories: StatCategory,
      stat_modifiers: StatModifier
    }

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