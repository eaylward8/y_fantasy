# frozen_string_literal: true

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

      def self.floatize(value)
        (value == "-") ? 0.0 : Types::Coercible::Float.call(value)
      end

      def self.dig_value(data, *keys)
        data&.dig(*keys)
      end

      def self.wrap_in_array(data)
        data.is_a?(Array) ? data : [data]
      end

      def self.no_op(data)
        data
      end
    end
  end
end
