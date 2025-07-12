# frozen_string_literal: true

module YFantasy
  module Transformations
    class CollectionMapper
      extend Forwardable

      def_delegator :@function, :call

      # TODO: would be cool if this class could detect subresources automatically instead of having to pass them in
      def initialize(collection, subresources: [])
        @collection = collection.to_sym
        @resource = T[:singularize].call(collection).to_sym
        @subresources = subresources
        @klass = Object.const_get("YFantasy::#{@resource.to_s.capitalize}") # TODO: create map of resources/classes instead of using const_get
        @function = compose_function
      end

      private

      def compose_function
        UserUnwrapper.new
          .>> KeyUnwrapper.new(@collection)
          .>> ResourceArrayFetcher.new(@resource)
          .>> ResourceUnwrapper.new(@subresources, collection: true)
          .>> Instantiator.new(@klass, collection: true)
      end
    end
  end
end
