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
        # wrap_in_array is needed when requesting a team's matchup for a single week
        fn = DefaultTransformer.new(:matchups) >> t(:map_value, :matchups, t(:wrap_in_array) >> map_matchups_fn)
        t(:guard, ->(data) { !data[:matchups].nil? }, fn)
      end
    end
  end
end
