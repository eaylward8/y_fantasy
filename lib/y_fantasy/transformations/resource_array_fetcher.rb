# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceArrayFetcher < BaseTransform
      def initialize(resource)
        @function = t(:dig_value, resource) >> t(:wrap_in_array) # TODO: get rid of this class?
        super(resource)
      end
    end
  end
end
