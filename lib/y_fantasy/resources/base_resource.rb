# frozen_string_literal: true

module YFantasy
  class BaseResource
    extend Dry::Initializer[undefined: false]
    include Subresourceable

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
        puts "\n YFantasy::Api::Client.get('#{resource_name}', '#{key}', #{subresources}) \n"
        data = YFantasy::Api::Client.get(resource_name, key, subresources)
        # TODO: can I have a single instance of these classes created when the gem is loaded?
        # Then we just reuse them, instead of calling .new on every request?
        if resource_name == :game
          Transformations::GameTransformer.new.call(data)
        elsif resource_name == :league
          Transformations::LeagueTransformer.new.call(data)
        elsif resource_name == :player
          Transformations::PlayerTransformer.new.call(data)
        elsif resource_name == :team
          Transformations::TeamTransformer.new.call(data)
        else
          Transformations::ResourceTransformer.new(resource_name).call(data)
        end
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

        to_s.partition("::").last.downcase.to_sym
      end

      def collection_name
        return if base_resource?

        :"#{resource_name}s"
      end

      private

      def base_resource?
        self == YFantasy::BaseResource
      end

      def instance_of(klass)
        Transformations::Instantiator.new(klass)
      end

      def array_of(klass)
        Transformations::Instantiator.new(klass, collection: true)
      end
    end

    # Instance methods
    # TODO: Is this needed?
    def key
      if (name = self.class.resource_name)
        public_send(:"#{name}_key")
      end
    end
  end
end
