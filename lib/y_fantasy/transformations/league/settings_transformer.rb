# frozen_string_literal: true

module YFantasy
  module Transformations
    module League
      class SettingsTransformer < BaseTransform
        def initialize
          @function = compose_function
          super
        end

        private

        def compose_function
          fn = t(
            :map_value,
            :settings,
            DefaultTransformer.new(:roster_positions) >> StatCategoriesTransformer.new >> StatModifiersTransformer.new
          )
          t(:guard, ->(data) { data.key?(:settings) }, fn)
        end
      end
    end
  end
end
