# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceMapper
      def initialize(data, resource, subresources: [])
        @data = data
        @resource = make_singular(resource).to_sym
        @subresources = Array(subresources)
        @klass = Object.const_get("YFantasy::#{@resource.to_s.capitalize}") # TODO: create map of resources/classes instead of using const_get
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

      # Can I make something like:
      # Unwrapper.new(:fantasy_content, @resource) >> SubresourceUnwrapper.new(data, subresources) >> Instantiator.for(@klass)
      def build_transformation
        KeyUnwrapper.for(:fantasy_content, @resource)
          .>> t(:guard, ->(data) { !@subresources.empty? }, ->(data) { subresource_transformations.call(data) })
          .>> Instantiator.for(@klass)
      end

      def subresource_transformations
        return ResourceUnwrapper.for(@subresources[0]) if @subresources.length == 1

        pipeline = ResourceUnwrapper.for(@subresources[0]).transformation

        @subresources[1..].each do |subresource|
          pipeline = pipeline.send(:>>, ResourceUnwrapper.for(subresource).transformation)
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
