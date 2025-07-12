# frozen_string_literal: true

module YFantasy
  module Transformations
    module CustomUnwrapperFunctions
      extend Dry::Transformer::Registry

      import Dry::Transformer::HashTransformations

      def self.stat_categories
        t(:unwrap, :stat_categories) >> t(:unwrap, :stats) >> t(:rename_keys, stat: :stat_categories)
      end

      def self.stat_modifiers
        t(:unwrap, :stat_modifiers) >> t(:unwrap, :stats) >> t(:rename_keys, stat: :stat_modifiers)
      end

      def self.settings
        resources = YFantasy::Settings.subresources
        t(:map_value, :settings, ->(data) { ResourceUnwrapper.new(resources).call(data) })
      end
    end
  end
end
