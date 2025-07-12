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
          fn = t(:map_value, :roster, ->(data) { DefaultTransformer.new(:players).call(data) })
          t(:guard, ->(data) { data.key?(:roster) }, fn)
        end
      end
    end
  end
end
