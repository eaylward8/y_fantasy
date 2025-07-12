# frozen_string_literal: true

module YFantasy
  class Player
    class DraftAnalysis < DependentSubresource
      # Required attributes
      option :average_cost, type: Types::Coercible::Float
      option :average_pick, type: Types::Coercible::Float
      option :average_round, type: Types::Coercible::Float
      option :percent_drafted, type: Types::Coercible::Float
    end
  end
end
