# frozen_string_literal: true

module YFantasy
  module Transformations
    class CollectionTransformer < BaseTransform
      def initialize(collection, return_array: true)
        @collection = collection.to_sym
        @resource = T[:singularize].call(collection).to_sym
        @return_array = return_array
        @function = compose_function
      end

      private

      def compose_function
        UserTransformer.new
          .>> t(:guard, ->(data) { data.key?(@collection) }, t(:map_value, @collection, transform_collection)) # TODO: clean up - pretty complex
          .>> t(:guard, ->(_data) { return_array? }, t(:dig_value, @collection))
      end

      def transform_collection
        t(:dig_value, @resource) >> t(:wrap_in_array) >> t(:map_array, ResourceTransformer.new(@resource))
      end

      def return_array?
        @return_array
      end
    end
  end
end
