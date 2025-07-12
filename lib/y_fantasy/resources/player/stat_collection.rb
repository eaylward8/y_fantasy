# frozen_string_literal: true

module YFantasy
  class Player
    class StatCollection < BaseSubresource
      # Required attributes
      option :coverage_type
      option :standard_stats, type: array_of(Stat)

      # Optional attributes
      option :advanced_stats, optional: true, type: array_of(Stat)
      option :season, optional: true, type: Types::Coercible::Integer
      option :week, optional: true, type: Types::Coercible::Integer
    end
  end
end
