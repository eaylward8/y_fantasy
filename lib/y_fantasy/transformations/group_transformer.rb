# frozen_string_literal: true

module YFantasy
  module Transformations
    class GroupTransformer < BaseTransform
      def initialize(nested: false)
        @nested = nested
        @function = compose_function
        super
      end

      private

      def compose_function
        t(:guard, ->(data) { data.key?(:group) }, t(:unwrap, :group))
          .>> transform_teams
          .>> transform_standings
          .>> instantiate
      end

      def transform_teams
        map_teams_fn = t(:map_array, Transformations.pickem_team_transformer(nested: true))
        DefaultTransformer.new(:teams) >> t(:map_value, :teams, map_teams_fn)
      end

      def transform_standings
        map_teams_fn = t(:map_array, Transformations.pickem_team_transformer(nested: true))
        t(:map_value, :standings, t(:rename_keys, team: :teams) >> t(:map_value, :teams, map_teams_fn))
      end

      def instantiate
        @nested ? t(:no_op) : Instantiator.new(YFantasy::Group)
      end
    end
  end
end
