# frozen_string_literal: true

module YFantasy
  class League
    class Scoreboard < DependentSubresource
      # Required attributes
      option :week, type: Types::Coercible::Integer

      # Subresources
      option :matchups, type: array_of(Matchup)

      has_subresources :matchups, dependent: true
    end
  end
end
