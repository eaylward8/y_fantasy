# frozen_string_literal: true

module YFantasy
  module Transformations
    class UserTransformer < BaseTransform
      def initialize
        @function = compose_function
      end

      private

      def compose_function
        fn = KeyUnwrapper.new(:users, :user) >> t(:reject_keys, [:guid])

        t(:guard, ->(data) { data.key?(:users) }, fn)
      end
    end
  end
end
