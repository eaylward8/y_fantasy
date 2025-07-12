# frozen_string_literal: true

module YFantasy
  class Team
    class Roster < DependentSubresource
      # Required attributes
      option :coverage_type
      option :is_editable, type: Types::Params::Bool
      option :players

      # Optional attributes
      option :date, optional: true, type: Types::Params::Date
      option :week, optional: true, type: Types::Coercible::Integer
    end
  end
end
