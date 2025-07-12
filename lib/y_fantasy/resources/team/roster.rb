# frozen_string_literal: true

module YFantasy
  class Team
    class Roster < BaseSubresource
      # Required attributes
      option :coverage_type
      option :is_editable, type: Types::Params::Bool
      option :players, type: array_of(Player)

      # Optional attributes
      option :date, optional: true, type: Types::Params::Date
      option :week, optional: true, type: Types::Coercible::Integer

      has_subresource :players, klass: Player
    end
  end
end
