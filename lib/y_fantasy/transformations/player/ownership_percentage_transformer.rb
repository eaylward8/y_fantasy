# frozen_string_literal: true

module YFantasy
  module Transformations
    module Player
      class OwnershipPercentageTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          fn = t(:rename_keys, percent_owned: :ownership_percentage)
          t(:guard, ->(data) { data.key?(:percent_owned) }, fn)
        end
      end
    end
  end
end
