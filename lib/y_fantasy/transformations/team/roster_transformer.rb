# frozen_string_literal: true

module YFantasy
  module Transformations
    module Team
      class RosterTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          t(:guard, ->(data) { data.key?(:roster) }, transform_players)
        end

        def transform_players
          map_players_fn = t(:map_array, Transformations.player_transformer(nested: true))
          fn = DefaultTransformer.new(:players) >> t(:map_value, :players, map_players_fn)

          t(:map_value, :roster, ->(data) { fn.call(data) })
        end
      end
    end
  end
end
