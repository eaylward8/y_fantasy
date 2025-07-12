# frozen_string_literal: true

module YFantasy
  class Player
    class Stat < DependentSubresource
      # Required attributes
      option :stat_id, type: Types::Coercible::Integer
      option :value, type: Transformations::T[:floatize]
    end
  end
end
