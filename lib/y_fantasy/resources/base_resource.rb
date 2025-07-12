# frozen_string_literal: true

module YFantasy
  class BaseResource
    extend Forwardable
    extend Dry::Initializer[undefined: false]
    include Subresourceable

    # Class methods
    class << self
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
