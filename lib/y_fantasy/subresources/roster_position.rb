# frozen_string_literal: true

module YFantasy
  class RosterPosition < DependentSubresource
    option :position
    option :abbreviation
    option :display_name
    option :position_type, optional: true
    option :is_bench, optional: true, type: Types::Params::Bool
  end
end
