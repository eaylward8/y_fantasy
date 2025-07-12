# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceUnwrapper < BaseTransform
      extend Forwardable

      def initialize(resources, collection: false)
        @resources = Array(resources)
        @collection = collection
        @function = compose_function
        super(resources)
      end

      private

      def compose_function
        fn = ->(data) { compose_resource_functions.call(data) }
        fn = t(:map_array, fn) if for_collection?
        t(:guard, ->(_data) { !@resources.empty? }, fn)
      end

      def compose_resource_functions
        @resources.map { |resource| function_for(resource) }.inject(:>>)
      end

      def function_for(resource)
        return CustomUnwrapperFunctions.send(resource) if CustomUnwrapperFunctions.respond_to?(resource)

        plural = t(:pluralize, resource).call.to_sym
        singular = t(:singularize, resource).call.to_sym

        t(:map_value, plural, t(:dig_value, singular))
      end

      def for_collection?
        @collection
      end
    end
  end
end
