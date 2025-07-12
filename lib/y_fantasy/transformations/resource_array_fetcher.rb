# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceArrayFetcher < BaseTransform
      extend Forwardable

      def initialize(resource)
        @function = t(:fetch_value, resource) >> t(:is, Hash, ->(hash) { [hash] })
        super(resource)
      end
    end
  end
end
