# frozen_string_literal: true

module YFantasy
  class CollectionProxy
    def initialize(resource, keys = [], scope_to_user: false)
      @resource = resource
      @keys = keys
      @scope_to_user = scope_to_user
      @subresources = []
      @client = YFantasy::Api::Client.new
    end

    def find_all(keys = [])
      @keys = keys
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
      collection
    end
    alias_method :to_a, :load
    alias_method :all, :load

    private

    def collection
      @collection ||=
        Transformations::CollectionMapper.new(@resource, subresources: @subresources).call(fetch_data)
    end

    def fetch_data
      @client.get(@resource, @keys, @subresources, scope_to_user: @scope_to_user)
    end

    # This is just to make irb/console output look better
    # Adapted from code found in ActiveRecord
    def inspect
      entries = collection.take(5).map do |entry|
        inspection = entry.instance_values.take(5).map do |k, v|
          next if v.nil?
          v.is_a?(Array) ? "#{k}: [#{v.first.class.name}...]" : "#{k}: #{v}"
        end

        "#<#{entry.class} #{inspection.compact.join(", ")}>"
      end

      entries[10] = "..." if entries.size == 11

      "#<#{self.class.name} [#{entries.join(", ")}]>"
    end

    def method_missing(method_name, *args, &block)
      if Array.instance_methods.include?(method_name)
        collection.send(method_name, *args, &block)
      else
        super(method_names, *args, &block)
      end
    end

    def respond_to_missing?(name, include_private = false)
      Array.instance_methods.include?(name) || super
    end
  end
end
