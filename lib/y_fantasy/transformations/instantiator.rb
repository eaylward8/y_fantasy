# frozen_string_literal: true

module YFantasy
  module Transformations
    class Instantiator < BaseTransform
      def initialize(klass, collection: false)
        @klass = klass
        @collection = collection
        @function = compose_function
        super(klass)
      end

      private

      def compose_function
        fn = t(->(data) { data.is_a?(Hash) ? @klass.new(**data) : data })
        for_collection? ? t(:map_array, fn) : fn
      end

      def for_collection?
        @collection
      end
    end
  end
end
