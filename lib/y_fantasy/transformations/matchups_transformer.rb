# frozen_string_literal: true

module YFantasy
  module Transformations
    class MatchupsTransformer < BaseTransform
      def initialize
        @function = compose_function
        super
      end

      private

      def compose_function
        map_teams_fn = t(:map_array, Transformations.team_transformer(nested: true))
        map_matchups_fn = t(:map_array, DefaultTransformer.new(:teams) >> t(:map_value, :teams, map_teams_fn))

        DefaultTransformer.new(:matchups) >> t(:map_value, :matchups, map_matchups_fn)
      end
    end
  end
end
