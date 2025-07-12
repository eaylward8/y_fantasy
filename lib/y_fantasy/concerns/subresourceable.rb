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

      def has_subresource(sub, klass:)
        klass.dependent? ? (dependent_subresources << sub) : (primary_subresources << sub)
        add_to_subresource_tree(sub, klass)

        define_method(sub) do
          ivar = :"@#{sub}"
          value = instance_variable_get(ivar)

          return value if self.class.respond_to?(:dependent?) && self.class.dependent?
          # `fetched?` is defined on Team::StatCollection to help identify whether or not a team's stats have been
          # already fetched from the Yahoo API. Yahoo values for team stats vary by sport and scoring type.
          # This helps prevent fetching team stats in an infinite loop.
          return value if value && !value.respond_to?(:fetched?)
          return value if value&.fetched?

          instance_variable_set(ivar, self.class.fetch_subresource(key, sub))
        end
      end

      def add_to_subresource_tree(subresource, klass)
        @subresource_tree ||= {}
        @subresource_tree[subresource] = klass.subresources
      end

      def subresource_tree
        @subresource_tree || {}
      end
    end
  end
end
