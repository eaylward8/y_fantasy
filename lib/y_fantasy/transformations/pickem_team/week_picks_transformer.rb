# frozen_string_literal: true

module YFantasy
  module Transformations
    module PickemTeam
      class WeekPicksTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          t(:guard, ->(data) { data.key?(:week_picks) }, transform_week_picks)
        end

        def transform_week_picks
          map_week_picks_fn = t(:map_array, transform_picks)
          DefaultTransformer.new(:week_picks) >> t(:map_value, :week_picks, map_week_picks_fn)
        end

        def transform_picks
          DefaultTransformer.new(:picks)
            .>> t(:map_value, :picks, t(:wrap_in_array) >> t(:map_array, t(:rename_keys, team: :team_key)))
        end
      end
    end
  end
end
