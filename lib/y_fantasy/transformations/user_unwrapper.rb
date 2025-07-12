# frozen_string_literal: true

module YFantasy
  module Transformations
    class UserUnwrapper < Dry::Transformer::Pipe
      import :guard, from: T
      import :unwrap, from: T
      import :reject_keys, from: T

      def self.pipeline
        new.transproc
      end

      define! do
        guard ->(data) { data.key?(:users) } do
          unwrap :users
          unwrap :user
          reject_keys [:guid]
        end
      end
    end
  end
end
