# frozen_string_literal: true

module YFantasy
  module Transformations
    class UserUnwrapper < BaseTransform
      def initialize
        @function = compose_function
      end

      private

      def compose_function
        fn = KeyUnwrapper.new(:users, :user) >> t(:reject_keys, [:guid])

        t(:guard, ->(data) { data.key?(:users) }, ->(data) { fn.call(data) })
      end
    end
  end
end
