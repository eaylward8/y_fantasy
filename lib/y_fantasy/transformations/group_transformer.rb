# frozen_string_literal: true

module YFantasy
  module Transformations
    class GroupTransformer < BaseTransform
      def initialize(nested: false)
        @nested = nested
        @function = compose_function
        super
      end

      private

      def compose_function
        # DefaultTransformer.new(:groups) >> t(:map_value, :groups, t(:wrap_in_array))
        t(:guard, ->(data) { data.key?(:group) }, t(:unwrap, :group))
          .>> instantiate
      end

      def instantiate
        @nested ? t(:no_op) : Instantiator.new(YFantasy::Group)
      end
    end
  end
end
