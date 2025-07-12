# frozen_string_literal: true

module YFantasy
  class RosterPosition < BaseSubresource
    option :position
    option :abbreviation, optional: true
    option :display_name, optional: true
    option :position_type, optional: true
    option :count, optional: true, type: Types::Coercible::Integer
    option :is_starting_position, optional: true, type: Types::Params::Bool
    option :is_bench, optional: true, type: Types::Params::Bool
  end
end
