# frozen_string_literal: true

module YFantasy
  class DependentSubresource
    extend Dry::Initializer[undefined: false]
    include Subresourceable

    class << self
      def dependent?
        true
      end

      def array_of(klass)
        Transformations::Instantiator.new(klass, collection: true)
      end
    end
  end
end
