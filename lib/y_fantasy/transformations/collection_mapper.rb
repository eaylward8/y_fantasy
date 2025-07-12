# frozen_string_literal: true

module YFantasy
  module Transformations
    class CollectionMapper
      extend Forwardable

      def_delegator :@function, :call

      # TODO: would be cool if this class could detect subresources automatically instead of having to pass them in
      def initialize(collection, subresources: [])
        @collection = collection.to_sym
        @resource = t(:singularize, collection).call.to_sym
        @subresources = subresources
        @klass = Object.const_get("YFantasy::#{@resource.to_s.capitalize}") # TODO: create map of resources/classes instead of using const_get
        @function = compose_function
      end

      private

      def t(*args)
        T[*args]
      end

      def compose_function
        KeyUnwrapper.new(:fantasy_content)
          .>> UserUnwrapper.new
          .>> KeyUnwrapper.new(@collection)
          .>> ResourceArrayFetcher.new(@resource)
          .>> ResourceUnwrapper.new(@subresources, for_collection: true)
          .>> Instantiator.for(@klass)
      end
    end
  end
end
