# frozen_string_literal: true

module YFantasy
  # NOTE: StatModifiers are only included in settings for certain league scoring types.
  class StatModifier < BaseSubresource
    # Required attributes
    option :stat_id, type: Types::Coercible::Integer
    option :value, type: Types::Coercible::Float
  end
end
