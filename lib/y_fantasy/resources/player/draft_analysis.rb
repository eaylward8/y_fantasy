# frozen_string_literal: true

module YFantasy
  class Player
    class DraftAnalysis < DependentSubresource
      # Required attributes
      option :average_cost, type: ->(v) { Transformations::T.floatize(v) }
      option :average_pick, type: ->(v) { Transformations::T.floatize(v) }
      option :average_round, type: ->(v) { Transformations::T.floatize(v) }
      option :percent_drafted, type: ->(v) { Transformations::T.floatize(v) * 100 }
    end
  end
end
