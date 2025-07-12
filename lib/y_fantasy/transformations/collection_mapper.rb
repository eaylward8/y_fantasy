# frozen_string_literal: true

module YFantasy
  module Transformations
    class CollectionMapper
      # TODO: would be cool if this class could detect subresources automatically instead of having to pass them in
      def initialize(data, collection, subresources: [])
        @data = data
        @collection = collection.to_sym
        @collection_singular = make_singular(collection).to_sym
        @subresources = subresources
        @klass = Object.const_get("YFantasy::#{@collection_singular.to_s.capitalize}") # TODO: create map of resources/classes instead of using const_get
        @transformation = build_transformation
      end

      def map
        @transformation.call(@data)
      end

      private

      def t(*args)
        T[*args]
      end

      # TODO: may be able to combine the (unwrap, collection) and the first guard transform and put it in ResourceUnwrapperOld
      def build_transformation
        t(:unwrap, :fantasy_content)
          .>> UserUnwrapper.pipeline
          .>> t(:unwrap, @collection)
          .>> t(:guard, ->(data) { data.fetch(@collection_singular).is_a?(Hash) }, t(:map_value, @collection_singular, ->(data) { [data] }))
          .>> t(:fetch_array, @collection_singular)
          .>> t(:guard, ->(data) { !@subresources.empty? }, t(:map_array, ->(data) { subresource_transformations.call(data) })) # turn this into class
          .>> Instantiator.for(@klass)
      end

      def subresource_transformations
        return ResourceUnwrapperOld.for(@subresources[0]) if @subresources.length == 1

        pipeline = ResourceUnwrapperOld.for(@subresources[0]).transformation

        @subresources[1..].each do |subresource|
          pipeline = pipeline.send(:>>, ResourceUnwrapperOld.for(subresource).transformation)
        end

        pipeline
      end

      def make_singular(resource)
        return resource unless resource.to_s.end_with?("s")

        resource.to_s[0...-1]
      end
    end
  end
end
