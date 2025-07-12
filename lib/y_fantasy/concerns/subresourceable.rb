# frozen_string_literal: true

module YFantasy
  module Subresourceable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def primary_subresources
        @primary_subresources ||= []
      end

      def dependent_subresources
        @dependent_subresources ||= []
      end

      def subresources
        primary_subresources | dependent_subresources
      end

      def has_subresources(*subs, dependent: false)
        subs.each do |sub|
          dependent ? (dependent_subresources << sub) : (primary_subresources << sub)

          define_method(sub) do
            ivar = "@#{sub}".to_sym
            value = instance_variable_get(ivar)
            return value if value
            return value if self.class.respond_to?(:dependent?) && self.class.dependent?

            instance_variable_set(ivar, self.class.fetch_subresource(key, sub))
          end
        end
      end
    end
  end
end
