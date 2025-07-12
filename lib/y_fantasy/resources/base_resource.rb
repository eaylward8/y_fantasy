# frozen_string_literal: true

module YFantasy
  # @abstract Base class for all "primary" Yahoo Fantasy Sports API resources.
  # @note Primary resources are those with a Yahoo Key/ID, that can be referenced in a Yahoo Fantasy API URL.
  #  This includes Game, League, Team, Player, Group, and PickemTeam.
  class BaseResource
    extend Forwardable
    extend Dry::Initializer[undefined: false]
    include Subresourceable

    # Error class for BaseResource exceptions
    class Error < StandardError
    end

    # CLASS METHODS
    class << self
      # Finds all resources of the current type
      # @param keys [Array<String, Symbol, Integer>] Keys to find resources by
      # @param with [Array<Symbol>, Symbol] Subresources to include with the response
      # @param scope_to_user [Boolean] Whether to scope the request to the authenticated user
      # @return [Array<BaseResource>] Collection of resources
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

      # Finds a single resource by key
      # @param key [String, Symbol, Integer] The key to find the resource by
      # @param with [Array<Symbol>, Symbol] Subresources to include with the response
      # @param options [Hash] Additional options for the request
      # @return [BaseResource] The requested resource
      # @raise [Error] If invalid options are provided
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

      # Always returns false for primary resources (anything that inherits from BaseResource)
      # @return [Boolean] False by default.
      def dependent?
        false
      end

      # Returns the resource name as a symbol
      # @return [Symbol, nil] The resource name or nil if this is the BaseResource
      def resource_name
        return if base_resource?

        to_s.split("::").last.scan(/[A-Z][a-z]+/).join("_").downcase.to_sym
      end

      # Returns the collection name (aka pluralized resource name)
      # @return [Symbol, nil] The collection name or nil if this is the BaseResource
      def collection_name
        return if base_resource?

        :"#{resource_name}s"
      end

      private

      # Determines if this is the base resource class
      # @return [Boolean] True if this is the BaseResource class
      def base_resource?
        self == YFantasy::BaseResource
      end

      # Creates a transformer that instantiates a single object of the given class
      # @param klass [Class] The class to instantiate
      # @return [Transformations::Instantiator] A transformer that instantiates the class
      def instance_of(klass)
        Transformations::Instantiator.new(klass)
      end

      # Creates a transformer that instantiates an array of objects of the given class
      # @param klass [Class] The class to instantiate
      # @return [Transformations::Instantiator] A transformer that instantiates an array of the class
      def array_of(klass)
        Transformations::Instantiator.new(klass, collection: true)
      end

      # Validates options hash for API requests
      # @param options [Hash] Options hash to validate
      # @raise [Error] If invalid options are provided
      def validate_options(options)
        return unless options[:scope_to_user]

        raise Error.new("`scope_to_user` is not valid when requesting a single resource. Use `.find_all`.")
      end
    end

    # INSTANCE METHODS

    # Returns the key of the resource
    # @return [Object, nil] The resource key or nil if not applicable
    def key
      if (name = self.class.resource_name)
        public_send(:"#{name}_key")
      end
    end
  end
end
