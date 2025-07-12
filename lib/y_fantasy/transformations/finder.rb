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
          roster: Team::RosterTransformer,
          standings: Team::StandingsTransformer
        }
      }

      # TODO: Clean up
      def self.find(resource, subresource = nil)
        return ResourceTransformer.new(resource) unless subresource
        return CollectionTransformer.new(subresource, return_array: false) if primary_collection?(subresource)

        transform_class = MAP.dig(resource, subresource)
        return unless transform_class
        return transform_class.new(subresource) if transform_class == DefaultTransformer

        transform_class.new
      end

      def self.primary_collection?(subresource)
        [:games, :leagues, :players, :teams].include?(subresource.to_sym)
      end
    end
  end
end
