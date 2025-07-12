# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceMapper
      def initialize(data, resource, subresources: [])
        @data = data
        @resource = make_singular(resource)
        @subresources = Array.wrap(subresources)
        @klass = "YFantasy::#{resource.to_s.classify}".constantize
        @transformation = build_transformation
      end

      def map
        puts "\n ResourceMapper#map \n"
        @transformation.call(@data)
      end

      private

      def t(*args)
        T[*args]
      end

      def build_transformation
        t(:unwrap, :fantasy_content)
          .>> t(:unwrap, @resource)
          .>> t(:guard, ->(data) { !@subresources.empty? }, ->(data) { subresource_transformations.call(data) })
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

      def make_singular(subresource)
        subresource.to_s.singularize.to_sym
      end
    end
  end
end
