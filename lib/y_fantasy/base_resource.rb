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
        subresources = Array(with).map(&:to_sym)
        SubresourceValidator.validate!(self, subresources)

        # TODO: move client stuff elsewhere?
        data = YFantasy::Api::Client.get(resource_name, key, subresources)
        Transformations::ResourceMapper.new(resource_name, subresources: subresources).call(data)
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
        return if base_resource?

        to_s.partition("::").last.downcase
      end

      def collection_name
        return if base_resource?

        "#{resource_name}s"
      end

      private

      def base_resource?
        self == YFantasy::BaseResource
      end

      def array_of(klass)
        Transformations::Instantiator.new(klass, collection: true)
      end
    end

    # Instance methods
    # TODO: Is this needed?
    def key
      if (name = self.class.resource_name)
        public_send("#{name}_key")
      end
    end
  end
end
