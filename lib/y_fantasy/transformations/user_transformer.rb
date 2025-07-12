# frozen_string_literal: true

module YFantasy
  module Transformations
    class UserTransformer < BaseTransform
      def initialize
        @function = compose_function
      end

      private

      def compose_function
        t(:dig_value, :users, :user) >> t(:reject_keys, [:guid])
      end
    end
  end
end
