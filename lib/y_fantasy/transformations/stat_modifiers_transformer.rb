# frozen_string_literal: true

module YFantasy
  module Transformations
    class StatModifiersTransformer < BaseTransform
      def initialize
        @function = compose_function
        super
      end

      private

      def compose_function
        fn = t(:map_value, :stat_modifiers, t(:dig_value, :stats, :stat))
        t(:guard, ->(data) { data.key?(:stat_modifiers) }, fn)
      end
    end
  end
end
