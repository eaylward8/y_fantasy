# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceUnwrapper < BaseTransform
      extend Forwardable

      def initialize(resources)
        @resources = Array(resources)
        @function = compose_function
        super(resources)
      end

      private

      def compose_function
        t(:guard, ->(_data) { !@resources.empty? }, ->(data) { compose_resource_functions.call(data) })
      end

      def compose_resource_functions
        @resources.map { |resource| function_for(resource) }.inject(:>>)
      end

      def function_for(resource)
        return CustomUnwrapperFunctions.send(resource) if CustomUnwrapperFunctions.respond_to?(resource)

        plural = t(:pluralize, resource).call.to_sym
        singular = t(:singularize, resource).call.to_sym

        t(:unwrap, plural) >> t(:rename_keys, singular => plural)
      end
    end
  end
end
