# frozen_string_literal: true

module YFantasy
  module Subresources
    class GameWeek < DependentResource
      option :week, type: Types::Coercible::Integer
      option :display_name
      option :start, type: Types::Params::Date
      option :end, type: Types::Params::Date
    end
  end
end
