# frozen_string_literal: true

module YFantasy
  module Subresourceable
    def self.included(base)
      base.include(InstanceMethods)
      base.extend(ClassMethods)
    end

    module InstanceMethods
      def fetched_subresources
        @fetched_subresources ||= Set.new
      end

      def add_fetched_subresources(subresources = [])
        Array(subresources).each do |subresource|
          case subresource
          when Symbol
            fetched_subresources << subresource
          when Hash
            key = subresource.keys.first
            fetched_subresources << key
            send(key).each do |sub_instance|
              sub_instance.add_fetched_subresources(subresource[key])
            end
          end
        end
      end
    end

    module ClassMethods
      # TODO: may not need these first 3 methods if the subresource_tree works the way I want it to
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

          # `fetched?` is defined on Team::StatCollection to help identify whether or not a team's stats have already
          # been fetched from the Yahoo API. Yahoo values for team stats vary by sport and scoring type.
          # This prevents fetching team stats in an infinite loop.
          should_return =
            (self.class.respond_to?(:dependent?) && self.class.dependent?) ||
            (value && value != [] && !value.respond_to?(:fetched?)) ||
            (value.respond_to?(:fetched?) && value.fetched?)

          return value if should_return

          value = instance_variable_set(ivar, self.class.fetch_subresource(key, sub))
          add_fetched_subresources(sub)
          value
        end
      end

      def fetch_subresource(key, subresource)
        resource = find(key, with: [subresource])
        resource.send(subresource)
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
