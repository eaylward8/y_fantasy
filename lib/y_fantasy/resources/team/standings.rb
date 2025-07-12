# frozen_string_literal: true

module YFantasy
  class Team
    class Standings < DependentSubresource
      # Required attributes
      option :points_for, type: Types::Coercible::Float
      option :rank, type: Types::Coercible::Integer

      # Optional attributes
      option :games_back, optional: true, type: Types::Coercible::Float
      option :playoff_seed, optional: true, type: Types::Coercible::Integer
      option :points_against, optional: true, type: Types::Coercible::Float
      option :points_back, optional: true, type: Types::Coercible::Float
      option :points_change, optional: true, type: Types::Coercible::Float
      option :streak, optional: true do
        option :type
        option :value, type: Types::Coercible::Integer
      end
      option :divisional_losses, optional: true, type: Types::Coercible::Integer
      option :divisional_ties, optional: true, type: Types::Coercible::Integer
      option :divisional_wins, optional: true, type: Types::Coercible::Integer
      option :total_losses, optional: true, type: Types::Coercible::Integer
      option :total_ties, optional: true, type: Types::Coercible::Integer
      option :total_wins, optional: true, type: Types::Coercible::Integer
      option :win_percentage, optional: true, type: Types::Coercible::Float

      alias_method :losses, :total_losses
      alias_method :ties, :total_ties
      alias_method :wins, :total_wins
    end
  end
end
