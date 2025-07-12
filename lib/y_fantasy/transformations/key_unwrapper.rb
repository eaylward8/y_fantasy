# frozen_string_literal: true

require "forwardable"

module YFantasy
  module Transformations
    class KeyUnwrapper
      extend Forwardable

      def self.for(*keys)
        return if keys.none?

        new(*keys)
      end

      def_delegator :@transproc, :>>

      def initialize(*keys)
        @pipe = init_pipe(*keys).new
        @transproc = @pipe.transproc
      end

      def call(data)
        @pipe.call(data)
      end

      private

      def init_pipe(*keys)
        Class.new(Dry::Transformer::Pipe) do
          import :unwrap, from: T

          define! do
            keys.each { |key| unwrap(key) }
          end
        end
      end
    end
  end
end
