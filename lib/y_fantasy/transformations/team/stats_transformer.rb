# frozen_string_literal: true

module YFantasy
  module Transformations
    module Team
      class StatsTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          t(:guard, ->(data) { data.key?(:team_stats) }, team_stats_transform)
            .>> t(:guard, ->(data) { data.key?(:team_remaining_games) }, team_remaining_games_transform)
            .>> t(:nest, :stats, [:team_stats, :team_points, :team_projected_points, :team_remaining_games])
        end

        def team_stats_transform
          t(:map_value, :team_stats, DefaultTransformer.new(:stats))
        end

        def team_remaining_games_transform
          t(:map_value, :team_remaining_games, KeyUnwrapper.new(:total))
        end
      end
    end
  end
end
