# frozen_string_literal: true

module YFantasy
  module Transformations
    class DefaultTransformer < BaseTransform
      def initialize(resource)
        @resource = resource
        @function = compose_function
        super(resource)
      end

      private

      def compose_function
        plural = t(:pluralize, @resource).call.to_sym
        singular = t(:singularize, @resource).call.to_sym

        t(:guard, t(:dig_value, plural, singular), t(:map_value, plural, t(:dig_value, singular)))
      end
    end
  end
end
