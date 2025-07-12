# frozen_string_literal: true

module YFantasy
  module Transformations
    # Base class for all transformations in the YFantasy module.
    #
    # @abstract Subclasses must set @function instance variable
    # @example Creating a custom transformation
    #   class MyTransform < BaseTransform
    #     def initialize(param)
    #       @function = ->(data) { transform_data(data, param) }
    #     end
    #
    #     private
    #
    #     def transform_data(data, param)
    #       # transformation logic here
    #     end
    #   end
    class BaseTransform
      extend Forwardable

      # Delegates transformation-related methods to the @function object
      # @!method >>(other)
      #   Function composition - chains this transformation with another
      #   @param other [#call] Another callable object to compose with
      #   @return [Proc] A new composed function
      # @!method call(*args)
      #   Invokes the transformation function
      #   @param args Arguments to pass to the transformation
      #   @return [Object] The transformed result
      # @!method [](*args)
      #   Alias for call
      #   @param args Arguments to pass to the transformation
      #   @return [Object] The transformed result
      def_delegators :@function, :>>, :call, :[]

      # Initializes a new transformation instance
      # @param args [Array] Arguments for initialization (used by subclasses)
      # @raise [RuntimeError] If @function is not properly set by the subclass
      def initialize(*args)
        ensure_function_set
      end

      # Helper method to call transformations provided by Dry::Transformer (see T module)
      # @param args [Array] Arguments to pass to Dry::Transformer
      # @return [Object] A new transformation object
      def t(*args)
        T[*args]
      end

      # Ensures that the transformation function is properly set
      # @raise [RuntimeError] If @function is not callable or does not respond to the required methods
      # @return [nil] if the function is properly set
      def ensure_function_set
        return if @function.respond_to?(:>>) && @function.respond_to?(:call)

        raise "Subclass must set @function instance variable"
      end
    end
  end
end
