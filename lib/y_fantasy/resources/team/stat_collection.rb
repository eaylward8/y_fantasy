# frozen_string_literal: true

module YFantasy
  class Team
    class StatCollection < DependentSubresource
      # Required attributes
      option :coverage_type
      option :stats, type: array_of(Stat)

      # Optional attributes
      option :season, optional: true, type: Types::Coercible::Integer
    end
  end
end
