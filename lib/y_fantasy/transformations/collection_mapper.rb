# frozen_string_literal: true

module YFantasy
  module Transformations
    class CollectionMapper
      # TODO: would be cool if this class could detect subresources automatically instead of having to pass them in
      def initialize(data, collection, subresources: [])
        @data = data
        @collection = collection.to_sym
        @collection_singular = make_singular(collection)
        @subresources = subresources
        @klass = "YFantasy::#{collection.to_s.classify}".constantize
        @transformation = build_transformation
      end

      def map
        @transformation.call(@data)
      end

      private

      def t(*args)
        T[*args]
      end

      # TODO: may be able to combine the (unwrap, collection) and the first guard transform and put it in ResourceUnwrapper
      def build_transformation
        t(:unwrap, :fantasy_content)
          .>> UserUnwrapper.pipeline
          .>> t(:unwrap, @collection)
          .>> t(:guard, ->(data) { data.fetch(@collection_singular).is_a?(Hash) }, t(:map_value, @collection_singular, ->(data) { [data] }))
          .>> t(:fetch_array, @collection_singular)
          .>> t(:guard, ->(data) { !@subresources.empty? }, t(:map_array, ->(data) { subresource_transformations.call(data) }))
          .>> Instantiator.for(@klass)
      end

      def subresource_transformations
        return ResourceUnwrapper.for(@subresources[0]) if @subresources.length == 1

        pipeline = ResourceUnwrapper.for(@subresources[0]).transformation

        @subresources[1..-1].each do |subresource|
          pipeline = pipeline.send(:>>, ResourceUnwrapper.for(subresource).transformation)
        end

        pipeline
      end

      def make_singular(jawn)
        jawn.to_s.singularize.to_sym
      end
    end
  end
end
