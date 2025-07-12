# frozen_string_literal: true

module YFantasy
  class DependentResource
    extend Dry::Initializer[undefined: false]

    def self.dependent?
      true
    end
  end
end
