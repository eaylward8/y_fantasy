# frozen_string_literal: true

require "dry/transformer/all"

module YFantasy
  module Transformations
    module T
      extend Dry::Transformer::Registry

      # TODO: remove unused stuff
      import Dry::Transformer::Coercions
      import Dry::Transformer::ArrayTransformations
      import Dry::Transformer::HashTransformations
      import Dry::Transformer::ClassTransformations
      import Dry::Transformer::ProcTransformations
      import Dry::Transformer::Conditional
      import Dry::Transformer::Recursion

      def self.pluralize(jawn)
        jawn = jawn.to_s
        jawn.end_with?("s") ? jawn : "#{jawn}s"
      end

      def self.singularize(jawn)
        jawn = jawn.to_s
        jawn.end_with?("s") ? jawn[0...-1] : jawn
      end

      def self.newify(data, klass)
        puts "\n Calling newify for: #{klass} \n"
        klass.new(**data)
      end

      # Input is a hash, output is array
      def self.fetch_array(data, key)
        puts "\n Calling T.fetch_array \n"
        data.fetch(key)
      end

      def self.stat_categories
        t(:unwrap, :stat_categories) >> t(:unwrap, :stats) >> t(:rename_keys, stat: :stat_categories)
      end

      # SUBRESOURCE_TRANSFORMS = {
      #   stat_categories: T[:unwrap, :stat_categories] >> T[:unwrap, :stats] >> T[:rename_keys, stat: :stat_categories]
      # }
    end
  end
end
