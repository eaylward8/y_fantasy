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
        UserUnwrapper.new
          .>> KeyUnwrapper.new(@collection)
          .>> ResourceArrayFetcher.new(@resource)
          .>> t(:map_array, ->(data) { ResourceTransformer.new(@resource).call(data) })
      end
    end
  end
end
