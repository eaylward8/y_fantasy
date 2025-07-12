# frozen_string_literal: true

module YFantasy
  module Transformations
    class BaseTransform
      extend Forwardable

      def_delegators :@function, :>>, :call

      def initialize(*args)
        ensure_function_set
      end

      def t(*args)
        T[*args]
      end

      def ensure_function_set
        return if @function.is_a?(Dry::Transformer::Function)

        raise "Subclass must set @function instance variable"
      end
    end
  end
end
