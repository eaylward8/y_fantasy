# frozen_string_literal: true

module YFantasy
  module Transformations
    class CollectionTransformer < BaseTransform
      def initialize(collection)
        @collection = collection.to_sym
        @resource = T[:singularize].call(collection).to_sym
        @function = compose_function
      end

      private

      def compose_function
        UserTransformer.new
          .>> t(:dig_value, @collection, @resource)
          .>> t(:wrap_in_array)
          .>> t(:map_array, Transformations.transformer_for(@resource))
      end
    end
  end
end
