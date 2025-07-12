# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceUnwrapperOld
      def self.for(resource)
        new(resource)
      end

      attr_reader :transformation

      def initialize(resource)
        @resource = resource
        @transformation = T.respond_to?(resource) ? T.send(resource) : standard_transform
      end

      def call(data)
        @transformation.call(data)
      end

      def standard_transform
        plural = make_plural(@resource).to_sym
        singular = make_singular(@resource).to_sym
        t(:unwrap, plural) >> t(:rename_keys, singular => plural)
      end

      private

      def t(*args)
        T[*args]
      end

      def make_plural(resource)
        return resource if resource.to_s.end_with?("s")

        resource.concat("s")
      end

      def make_singular(resource)
        return resource unless resource.to_s.end_with?("s")

        resource.to_s[0...-1]
      end
    end
  end
end
