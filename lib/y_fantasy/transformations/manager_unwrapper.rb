# frozen_string_literal: true

module YFantasy
  module Transformations
    class ManagerUnwrapper < BaseTransform
      def initialize(collection: false)
        @collection = collection
        @function = compose_function
      end

      private

      def compose_function
        fn = ResourceUnwrapper.new(:managers) >> t(:map_value, :managers, t(:wrap_in_array))
        fn = t(:map_array, fn) if for_collection?
        t(:guard, guard_function, ->(data) { fn.call(data) })
      end

      def guard_function
        for_collection? ? ->(data) { data.first.key?(:managers) } : ->(data) { data.key?(:managers) }
      end

      def for_collection?
        @collection
      end
    end
  end
end
