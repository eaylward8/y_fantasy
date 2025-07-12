# frozen_string_literal: true

module YFantasy
  class BaseResource
    extend Forwardable
    extend Dry::Initializer[undefined: false]
    include Subresourceable

    # Class methods
    class << self
      # TODO: get rid of CollectionProxy? Is it more complicated than useful?
      # Collections
      # def for_current_user
      #   # TODO: this is not creating the correct URLs for anything besides games
      #   # Ex: League.for_current_user is producing 'https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/leagues'
      #   # But it should produce: https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games/leagues
      #   # OR: https://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games;game_codes=nfl/leagues
      #   CollectionProxy.new(collection_name, scope_to_user: true)
      # end

      def find_all(keys = [], with: [], scope_to_user: false)
        keys = Array(keys)
        subresources = Transformations::T.wrap_in_array(with)
        data = YFantasy::Api::Client.get(
          collection_name, keys: keys, subresources: subresources, scope_to_user: scope_to_user
        )
        resources = Transformations::CollectionTransformer.new(collection_name).call(data)
        resources.each { |resource| resource.add_fetched_subresources(subresources) }
        resources
      end

      # Individual resources
      def find(key, with: [], **options)
        validate_options(options)
        subresources = Transformations::T.wrap_in_array(with)
        SubresourceValidator.validate!(self, subresources)
        # TODO: Remove
        # puts "\n YFantasy::Api::Client.get('#{resource_name}', '#{key}', #{subresources}, #{options}) \n"

        data = YFantasy::Api::Client.get(resource_name, keys: key, subresources: subresources, **options)
        resource = Transformations.transformer_for(resource_name).call(data)
        resource.add_fetched_subresources(subresources)
        resource
      end

      # Other class methods
      def dependent?
        false
      end

      def resource_name
        return if base_resource?

        to_s.split("::").last.scan(/[A-Z][a-z]+/).join("_").downcase.to_sym
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

      def validate_options(options)
        return unless options[:scope_to_user]

        raise Error.new("`scope_to_user` is not valid when requesting a single resource. Use `.find_all`.")
      end
    end

    # Instance methods
    def key
      if (name = self.class.resource_name)
        public_send(:"#{name}_key")
      end
    end

    class Error < StandardError
    end
  end
end
