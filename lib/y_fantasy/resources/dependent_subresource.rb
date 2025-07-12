# frozen_string_literal: true

module YFantasy
  class DependentSubresource
    extend Dry::Initializer[undefined: false]
    include Subresourceable

    class << self
      def dependent?
        true
      end

      def resource_name
        return if self == YFantasy::DependentSubresource

        to_s.split("::").last.scan(/[A-Z][a-z]+/).join("_").downcase.to_sym
      end

      private

      def array_of(klass)
        Transformations::Instantiator.new(klass, collection: true)
      end
    end
  end
end
