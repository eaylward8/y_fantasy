# frozen_string_literal: true

module YFantasy
  class Stat < BaseSubresource
    # Required attributes
    option :stat_id, type: Types::Coercible::Integer
    option :value
  end
end
