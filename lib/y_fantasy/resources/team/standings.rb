# frozen_string_literal: true

module YFantasy
  class Team
    class Standings < DependentSubresource
      # Required attributes
      option :points_for, type: Types::Coercible::Float
      option :rank, type: Types::Coercible::Integer

      # Optional attributes
      option :games_back, optional: true, type: Types::Coercible::Float
      option :losses, optional: true, type: Types::Coercible::Integer
      option :percentage, optional: true, type: Types::Coercible::Float
      option :playoff_seed, optional: true, type: Types::Coercible::Integer
      option :points_against, optional: true, type: Types::Coercible::Float
      option :points_back, optional: true, type: Types::Coercible::Float
      option :points_change, optional: true, type: Types::Coercible::Float
      option :streak, optional: true, type: ->(h) { Transformations::T.numeric_values_to_ints(h) }
      option :ties, optional: true, type: Types::Coercible::Integer
      option :wins, optional: true, type: Types::Coercible::Integer
    end
  end
end
