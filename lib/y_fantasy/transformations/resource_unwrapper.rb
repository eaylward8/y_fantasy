# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceUnwrapper
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
        plural = make_plural(@resource)
        singular = make_singular(@resource)
        t(:unwrap, plural) >> t(:rename_keys, singular => plural)
      end

      private

      def t(*args)
        T[*args]
      end

      def make_plural(jawn)
        jawn.to_s.pluralize.to_sym
      end

      def make_singular(jawn)
        jawn.to_s.singularize.to_sym
      end
    end
  end
end
