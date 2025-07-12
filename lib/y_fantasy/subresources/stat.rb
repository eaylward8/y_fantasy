# frozen_string_literal: true

module YFantasy
  module Subresources
    class Stat < DependentResource
      option :stat_id
      option :name
      option :display_name
      option :sort_order
      option :is_composite_stat, optional: true, type: Types::Params::Bool
      option :position_types, optional: true, type: ->(h) { h.values.flatten }
      option :base_stats, optional: true, type: ->(h) { h.values.flatten }
    end
  end
end
