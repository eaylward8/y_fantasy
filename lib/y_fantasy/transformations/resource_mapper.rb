# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceMapper
      def initialize(data, resource, subresources: [])
        @data = data
        @resource = T[:singularize].call(resource).to_sym
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
        KeyUnwrapper.new(:fantasy_content, @resource)
          .>> t(:guard, ->(_data) { !@subresources.empty? }, ->(data) { unwrap_subresources(data) })
          .>> Instantiator.for(@klass)
      end

      def unwrap_subresources(data)
        ResourceUnwrapper.new(@subresources).call(data)
      end
    end
  end
end
