# frozen_string_literal: true

module YFantasy
  module Transformations
    module CustomUnwrapperFunctions
      extend Dry::Transformer::Registry

      import Dry::Transformer::HashTransformations

      def self.stat_categories
        t(:unwrap, :stat_categories) >> t(:unwrap, :stats) >> t(:rename_keys, stat: :stat_categories)
      end
    end
  end
end
