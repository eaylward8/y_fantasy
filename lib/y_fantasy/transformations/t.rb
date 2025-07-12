# frozen_string_literal: true

require "dry/transformer/all"

module YFantasy
  module Transformations
    module T
      extend Dry::Transformer::Registry

      import Dry::Transformer::ArrayTransformations
      import Dry::Transformer::Coercions
      import Dry::Transformer::Conditional
      import Dry::Transformer::HashTransformations

      # https://philadelphiaencyclopedia.org/essays/jawn/
      def self.pluralize(jawn)
        jawn = jawn.to_s
        jawn.end_with?("s") ? jawn : "#{jawn}s"
      end

      def self.singularize(jawn)
        jawn = jawn.to_s
        jawn.end_with?("s") ? jawn[0...-1] : jawn
      end

      def self.dig_value(data, *keys)
        data.dig(*keys)
      end

      def self.wrap_in_array(data)
        data.is_a?(Array) ? data : [data]
      end

      def self.map_numeric_values(data, method: :to_i)
        data.transform_values { |v| v.match?(/\d/) ? v.send(method) : v }
      end
    end
  end
end
