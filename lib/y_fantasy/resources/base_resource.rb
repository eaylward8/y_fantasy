# frozen_string_literal: true

module YFantasy
  class BaseResource
    extend Forwardable
    extend Dry::Initializer[undefined: false]
    include Subresourceable

    # Class methods
    class << self
      # Collections
      def for_current_user
        # TODO: this is not creating the correct URLs for anything besides games
        # Ex: League.for_current_user is producing 'https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/leagues'
        # But it should produce: https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games/leagues
        # OR: https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games;game_codes=nfl/leagues
        CollectionProxy.new(collection_name, scope_to_user: true)
      end

      def find_all(keys = [])
        CollectionProxy.new(collection_name, keys)
      end

      # Individual resources
      def find(key, with: [], week: nil)
        subresources = Array(with)
        SubresourceValidator.validate!(self, subresources)
        puts "\n YFantasy::Api::Client.get('#{resource_name}', '#{key}', #{subresources}) \n"
        data = YFantasy::Api::Client.get(resource_name, key, subresources, week: week)
        Transformations.transformer_for(resource_name).call(data)
      end

      def fetch_subresource(key, subresource)
        resource = find(key, with: [subresource])
        resource.send(subresource)
      end

      # Other class methods
      def dependent?
        false
      end

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
