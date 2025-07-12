# frozen_string_literal: true

module YFantasy
  class StatCategory < DependentSubresource
    # Required attributes
    option :display_name
    option :name
    option :sort_order, type: Types::Coercible::Integer
    option :stat_id, type: Types::Coercible::Integer

    # Optional attributes
    option :abbr, optional: true
    option :base_stats, optional: true, type: ->(h) { h.values.flatten }
    option :enabled, optional: true, type: Types::Params::Bool
    option :group, optional: true
    option :is_composite_stat, optional: true, type: Types::Params::Bool
    option :is_only_display_stat, optional: true, type: Types::Params::Bool
    option :position_type, optional: true
    option :position_types, optional: true, type: ->(h) { h.values.flatten }
  end
end
