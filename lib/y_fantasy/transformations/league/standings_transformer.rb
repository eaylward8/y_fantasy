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
          fn = t(:map_value, :standings, ->(data) { {teams: CollectionTransformer.new(:teams).call(data)} })
          t(:guard, ->(data) { data.key?(:standings) }, fn)
        end
      end
    end
  end
end
