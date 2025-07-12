# frozen_string_literal: true

require "forwardable"

module YFantasy
  module Transformations
    class KeyUnwrapper
      extend Forwardable

      def_delegators :@transproc, :>>, :call

      def initialize(*keys)
        @transproc = pipe(*keys).transproc
      end

      private

      def pipe(*keys)
        Class.new(Dry::Transformer::Pipe) do
          import :unwrap, from: T

          define! do
            keys.each { |key| unwrap(key) }
          end
        end.new
      end
    end
  end
end
