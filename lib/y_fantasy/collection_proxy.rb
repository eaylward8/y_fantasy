# frozen_string_literal: true

module YFantasy
  class CollectionProxy
    def initialize(collection_name, keys = [], scope_to_user: false)
      @collection_name = collection_name
      @keys = Array(keys)
      @scope_to_user = scope_to_user
      @subresources = []
    end

    def find_all(keys = [])
      @keys = Array(keys)
      self
    end

    def with(*subresources)
      @subresources.push(*subresources)
      self
    end

    def for_current_user
      @scope_to_user = true
      self
    end

    def load
      ensure_collection
      ensure_keys

      collection
    end
    alias_method :to_a, :load
    alias_method :all, :load

    private

    def client
      @client ||= YFantasy::Api::Client.new
    end

    def collection
      @collection ||=
        Transformations::CollectionTransformer.new(@collection_name).call(fetch_data)
    end

    def fetch_data
      puts "\n YFantasy::Api::Client.get('#{@collection_name}', #{@keys}, #{@subresources}, scope_to_user: #{@scope_to_user}) \n"
      client.get(@collection_name, @keys, @subresources, scope_to_user: @scope_to_user)
    end

    def ensure_collection
      raise CollectionNameError if @collection_name.to_s.empty?
    end

    def ensure_keys
      raise MissingKeysError.new("No keys provided for #{@collection_name} collection") if @keys.compact.empty?
    end

    # :nocov:
    def method_missing(method_name, *args, &block)
      if Array.instance_methods.include?(method_name)
        collection.send(method_name, *args, &block)
      else
        super(method_name, *args, &block)
      end
    end
    # :nocov:

    def respond_to_missing?(name, include_private = false)
      Array.instance_methods.include?(name) || super
    end

    class CollectionNameError < StandardError
      def initialize(msg = "No collection name provided")
        super
      end
    end

    class MissingKeysError < StandardError
      def initialize(msg = "No keys provided")
        super
      end
    end

    # This is just to make irb/console output look better
    # Adapted from code found in ActiveRecord
    # :nocov:
    def inspect
      entries = collection.take(5).map do |entry|
        inspection = entry.instance_variables.take(2).map do |ivar|
          val = entry.instance_variable_get(ivar)
          next if val.nil?
          val.is_a?(Array) ? "#{ivar}: [#{val.first.class.name}...]" : "#{ivar}: #{val}"
        end

        "#<#{entry.class} #{inspection.compact.join(", ")}>"
      end

      entries[10] = "..." if entries.size == 11

      "#<#{self.class.name} [#{entries.join(", ")}]>"
    end
    # :nocov:
  end
end
