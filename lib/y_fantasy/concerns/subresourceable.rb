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

      def subresource_tree
        tree = {}

        dependent_subresources.each do |sub|
          tree[sub] = ResourceFinder.find_dependent(sub).subresource_tree
        end

        primary_subresources.each do |sub|
          tree[sub] = ResourceFinder.find_primary(sub).subresource_tree
        end

        tree.any? ? tree : nil
      end

      def has_subresources(*subs, dependent: false)
        subs.each do |sub|
          dependent ? (dependent_subresources << sub) : (primary_subresources << sub)

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
      end
    end
  end
end
