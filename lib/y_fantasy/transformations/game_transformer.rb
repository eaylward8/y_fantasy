# frozen_string_literal: true

module YFantasy
  module Transformations
    class GameTransformer < BaseTransform
      def initialize
        @function = compose_function
        super
      end

      private

      def compose_function
        t(:guard, ->(data) { data.key?(:game) }, t(:unwrap, :game))
          .>> transform_game_weeks
          .>> transform_position_types
          .>> transform_roster_positions
          .>> transform_stat_categories
          .>> Instantiator.new(YFantasy::Game)
      end

      def transform_game_weeks
        DefaultTransformer.new(:game_weeks)
      end

      def transform_position_types
        Game::PositionTypesTransformer.new
      end

      def transform_roster_positions
        DefaultTransformer.new(:roster_positions)
      end

      def transform_stat_categories
        StatCategoriesTransformer.new
      end
    end
  end
end
