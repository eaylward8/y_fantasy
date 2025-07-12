# frozen_string_literal: true

module YFantasy
  module Transformations
    module League
      class StandingsTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          map_teams_fn = t(:map_array, TeamTransformer.new(include_matchups: false))
          map_standings_fn = t(:map_value, :standings, DefaultTransformer.new(:teams) >> t(:map_value, :teams, map_teams_fn))
          t(:guard, ->(data) { data.key?(:standings) }, map_standings_fn)
        end
      end
    end
  end
end
