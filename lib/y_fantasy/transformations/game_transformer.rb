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
          .>> transform_groups
          .>> transform_position_types
          .>> transform_roster_positions
          .>> transform_stat_categories
          .>> Instantiator.new(YFantasy::Game)
      end

      def transform_game_weeks
        DefaultTransformer.new(:game_weeks)
      end

      def transform_groups
        map_groups_fn = t(:map_array, Transformations.group_transformer(nested: true))
        # wrap_in_array is needed when there is only 1 group
        fn = DefaultTransformer.new(:groups) >> t(:map_value, :groups, t(:wrap_in_array) >> map_groups_fn)
        t(:guard, ->(data) { !data[:groups].nil? }, fn)
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
