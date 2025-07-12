# frozen_string_literal: true

module YFantasy
  class Group
    # Standings for a Yahoo Fantasy NFL Survival Group
    class Standings < BaseSubresource
      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------
      option :teams, array_of(PickemTeam)
    end
  end
end
