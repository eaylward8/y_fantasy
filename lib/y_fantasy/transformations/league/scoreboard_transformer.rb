# frozen_string_literal: true

module YFantasy
  module Transformations
    module League
      class ScoreboardTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          fn = t(:map_value, :scoreboard, MatchupsTransformer.new)
          t(:guard, ->(data) { data.key?(:scoreboard) }, fn)
        end
      end
    end
  end
end
