# frozen_string_literal: true

module YFantasy
  class League
    # League scoreboard for a specific week
    class Scoreboard < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------
      option :week, type: Types::Coercible::Integer
      option :matchups, type: array_of(Matchup)
    end
  end
end
