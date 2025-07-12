# frozen_string_literal: true

module YFantasy
  module Transformations
    class Instantiator
      def self.for(klass)
        new(klass)
      end

      def initialize(klass)
        @klass = klass
        @single_transformation = t(:newify, @klass)
        @array_transformation = t(:map_array, @single_transformation)
      end

      def t(*args)
        T[*args]
      end

      def call(data)
        data.is_a?(Array) ? @array_transformation.call(data) : @single_transformation.call(data)
      end
    end
  end
end
