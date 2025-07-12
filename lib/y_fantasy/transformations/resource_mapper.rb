# frozen_string_literal: true

module YFantasy
  module Transformations
    class ResourceMapper
      extend Forwardable

      def_delegator :@function, :call

      # CLASS_MAP = {
      #   game: YFantasy::Game,

      # }

      def initialize(resource, subresources: [])
        @resource = resource.to_sym
        @subresources = Array(subresources)
        @klass = Object.const_get("YFantasy::#{@resource.to_s.capitalize}") # TODO: create map of resources/classes instead of using const_get
        @function = compose_function
      end

      private

      def compose_function
        KeyUnwrapper.new(@resource)
          .>> ResourceUnwrapper.new(@subresources)
          .>> Instantiator.new(@klass)
      end
    end
  end
end
