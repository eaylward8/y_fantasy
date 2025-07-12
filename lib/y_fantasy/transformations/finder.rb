# frozen_string_literal: true

module YFantasy
  module Transformations
    class Finder
      MAP = {
        game: {
          game_weeks: DefaultTransformer,
          position_types: Game::PositionTypesTransformer,
          roster_positions: DefaultTransformer,
          stat_categories: StatCategoriesTransformer
        },
        league: {
          draft_results: DefaultTransformer,
          scoreboard: League::ScoreboardTransformer,
          settings: League::SettingsTransformer,
          standings: League::StandingsTransformer
        },
        player: {
          ownership_percentage: Player::OwnershipPercentageTransformer,
          stats: Player::StatsTransformer
        },
        team: {
          draft_results: DefaultTransformer,
          # matchups: MatchupsTransformer,
          matchups: CollectionTransformer,
          roster: Team::RosterTransformer,
          stats: Team::StatsTransformer,
          team_standings: Team::StandingsTransformer
        }
      }

      # TODO: Clean up
      def self.find(resource, subresource = nil)
        return ResourceTransformer.new(resource) unless subresource

        transform_class = MAP.dig(resource, subresource)
        return unless transform_class
        return transform_class.new(subresource) if transform_class == DefaultTransformer

        transform_class.new
      end
    end
  end
end
