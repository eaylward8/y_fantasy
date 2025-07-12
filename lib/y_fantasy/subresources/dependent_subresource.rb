# frozen_string_literal: true

module YFantasy
  class DependentSubresource
    extend Dry::Initializer[undefined: false]

    def self.dependent?
      true
    end
  end
end
