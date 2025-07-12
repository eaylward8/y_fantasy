# frozen_string_literal: true

module YFantasy
  class SubresourceValidator
    def self.validate!(klass, subresources = [])
      new(klass, subresources).validate!
    end

    def initialize(klass, subresources = [])
      @contract = Contract.new(klass: klass)
      @subresources = Array(subresources)
    end

    def validate!
      return true if @subresources.empty?

      result = @contract.call(subresources: @subresources)
      return true if result.success?

      raise InvalidSubresourceError.new(result.errors.to_h.to_s)
    end

    class Contract < Dry::Validation::Contract
      option :klass

      params do
        required(:subresources).value(:array)
      end

      # TODO: Simplify this. It's gotten too complicated.
      rule(:subresources).each do
        fail_msg = "#{value} is not a valid subresource of #{klass}"
        next key.failure(fail_msg) unless value.is_a?(Symbol) || value.is_a?(Hash)

        if value.is_a?(Symbol)
          next if klass.subresource_tree.key?(value)

          key.failure(fail_msg)
        elsif value.is_a?(Hash)
          sub, nested_subs = value.keys.first, Array(value.values.first)
          valid_nested_subs = klass.subresource_tree.dig(sub)
          next key.failure(fail_msg) if !valid_nested_subs

          nested_subs.each do |nested_sub|
            if nested_sub.is_a?(Hash)
              nested_klass = YFantasy.const_get(Transformations::T.singularize(nested_sub.keys.first).capitalize)
              next if SubresourceValidator.new(nested_klass, Array(nested_sub.values.first))
            end

            next if valid_nested_subs.include?(nested_sub)
            key.failure("#{nested_sub} is not a valid subresource of #{sub}")
          end
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
