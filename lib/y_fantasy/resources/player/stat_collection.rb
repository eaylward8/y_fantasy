# frozen_string_literal: true

module YFantasy
  class Player
    class StatCollection < DependentSubresource
      # Required attributes
      option :coverage_type
      option :season, type: Types::Coercible::Integer
      option :standard_stats, type: array_of(Stat)

      # Optional attributes
      option :advanced_stats, optional: true, type: array_of(Stat)
    end
  end
end
