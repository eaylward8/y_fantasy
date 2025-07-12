# frozen_string_literal: true

module YFantasy
  class Player
    # Draft statistics for a player in Yahoo Fantasy Sports
    class DraftAnalysis < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------

      # @!attribute [r] average_cost
      # @return [Float] the average cost of this player in auction drafts
      option :average_cost, type: ->(v) { Transformations::T.floatize(v) }

      # @!attribute [r] average_pick
      # @return [Float] the average pick used to draft this player
      option :average_pick, type: ->(v) { Transformations::T.floatize(v) }

      # @!attribute [r] average_round
      # @return [Float] the player's average draft round
      option :average_round, type: ->(v) { Transformations::T.floatize(v) }

      # @!attribute [r] percent_drafted
      # @return [Float] the percentage of drafts in which this player was selected
      option :percent_drafted, type: ->(v) { Transformations::T.floatize(v) * 100 }
    end
  end
end
