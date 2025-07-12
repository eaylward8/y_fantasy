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

      def compose_function
        @resources.map { |resource| function_for(resource) }.inject(:>>)
      end

      def function_for(resource)
        plural = t(:pluralize, resource).call.to_sym
        singular = t(:singularize, resource).call.to_sym

        t(:unwrap, plural) >> t(:rename_keys, singular => plural)
      end
    end
  end
end
