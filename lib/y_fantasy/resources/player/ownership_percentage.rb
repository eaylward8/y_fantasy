# frozen_string_literal: true

module YFantasy
  class Player
    class OwnershipPercentage < DependentSubresource
      # Required attributes
      option :coverage_type
      option :delta, type: Types::Coercible::Integer
      option :value, type: Types::Coercible::Integer
      option :week, type: Types::Coercible::Integer
    end
  end
end
