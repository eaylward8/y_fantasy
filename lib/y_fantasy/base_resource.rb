# frozen_string_literal: true

module YFantasy
  class BaseResource
    extend Dry::Initializer[undefined: false]
    include Concerns::Subresourceable

    # Class methods
    class << self
      # Collections
      def for_current_user
        CollectionProxy.new(collection_name, scope_to_user: true)
      end

      def find_all(keys = [])
        CollectionProxy.new(collection_name, keys)
      end

      # Individual resources
      def find(key, with: [])
        subresources = Array.wrap(with)
        SubresourceValidator.new(self, subresources).validate! unless subresources.empty?

        client = YFantasy::Api::Client.new

        Transformations::ResourceMapper.new(
          client.get(resource_name, key, subresources),
          resource_name,
          subresources: subresources
        ).map
      end

      def fetch_subresource(key, subresource)
        resource = find(key, with: [subresource])
        resource.send(subresource)
      end

      # Other class methods
      # def dependent?
      #   false
      # end

      def resource_name
        return if self == YFantasy::BaseResource

        to_s.demodulize.downcase
      end

      def collection_name
        resource_name&.pluralize
      end

      private

      def array_of(klass)
        Transformations::Instantiator.for(klass)
      end
    end

    # Instance methods
    def key
      if (name = self.class.resource_name)
        public_send("#{name}_key")
      end
    end
  end
end
