# frozen_string_literal: true

module YFantasy
  module Transformations
    class KeyUnwrapper
      def self.for(*keys)
        return if keys.none?

        new(*keys).pipe.transproc
      end

      attr_reader :pipe

      def initialize(*keys)
        @pipe = init_pipe(*keys).new
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
