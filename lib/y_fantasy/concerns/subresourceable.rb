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
        # Using wrap_in_array here because Array() will convert a hash to array
        Transformations::T.wrap_in_array(subresources).each do |subresource|
          case subresource
          when Symbol
            fetched_subresources << subresource
          when Hash
            key = subresource.keys.first
            fetched_subresources << key
            send(key)&.each do |sub_instance|
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
        check_inheritance # This smells
        klass.dependent? ? (dependent_subresources << sub) : (primary_subresources << sub)
        add_to_subresource_tree(sub, klass)

        define_method(sub) do
          ivar = :"@#{sub}"
          value = instance_variable_get(ivar)
          return value if (value && value != []) || fetched_subresources.include?(sub)

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

      def check_inheritance
        return if superclass == YFantasy::BaseResource || superclass == YFantasy::BaseSubresource

        raise YFantasy::Subresourceable::Error.new("#{self} does not inherit from BaseResource")
      end
    end

    class Error < StandardError
    end
  end
end
