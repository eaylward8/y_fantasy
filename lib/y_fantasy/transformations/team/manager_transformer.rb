# frozen_string_literal: true

module YFantasy
  module Transformations
    module Team
      class ManagerTransformer < BaseTransform
        def initialize
          @function = compose_function
        end

        private

        def compose_function
          DefaultTransformer.new(:managers) >> t(:map_value, :managers, t(:wrap_in_array))
        end
      end
    end
  end
end
