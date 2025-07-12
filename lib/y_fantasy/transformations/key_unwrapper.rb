# frozen_string_literal: true

module YFantasy
  module Transformations
    class KeyUnwrapper < BaseTransform
      def initialize(*keys)
        @function = keys.map { |key| t(:unwrap, key) }.inject(:>>)
        super(*keys)
      end
    end
  end
end
