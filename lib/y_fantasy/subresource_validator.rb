# frozen_string_literal: true

module YFantasy
  class SubresourceValidator
    def initialize(klass, subresources)
      @contract = Contract.new(klass: klass)
      @subresources = subresources
    end

    def validate!
      result = @contract.call(subresources: @subresources)
      return true if result.success?

      raise InvalidSubresourceError.new(result.errors.to_h.to_s)
    end

    class Contract < Dry::Validation::Contract
      option :klass

      params do
        required(:subresources).value(:array)
      end

      rule(:subresources).each do
        fail_msg = "#{value} is not a valid subresource of #{klass}"

        next key.failure(fail_msg) unless value.is_a?(Symbol) || value.is_a?(Hash)

        if value.is_a?(Symbol)
          next if klass.subresources.include?(value)

          key.failure(fail_msg)
        elsif value.is_a?(Hash)
          # TODO: implement nested subresource checks
        end
      end
    end

    class InvalidSubresourceError < StandardError
      def initialize(msg = "Invalid subresource(s)")
        super
      end
    end
  end
end
