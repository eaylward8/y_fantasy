# frozen_string_literal: true

module YFantasy
  module Transformations
    module Game
      class PositionTypesTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          fn = DefaultTransformer.new(:position_types) >> t(:map_value, :position_types, t(:wrap_in_array))
          t(:guard, ->(data) { data.key?(:position_types) }, fn)
        end
      end
    end
  end
end
