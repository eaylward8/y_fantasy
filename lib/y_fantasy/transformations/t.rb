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

      # https://philadelphiaencyclopedia.org/essays/jawn/
      def self.pluralize(jawn)
        jawn = jawn.to_s
        jawn.end_with?("s") ? jawn : "#{jawn}s"
      end

      def self.singularize(jawn)
        jawn = jawn.to_s
        jawn.end_with?("s") ? jawn[0...-1] : jawn
      end

      def self.fetch_value(data, key)
        puts "\n Calling T.fetch_value \n"
        data.fetch(key)
      end
    end
  end
end
