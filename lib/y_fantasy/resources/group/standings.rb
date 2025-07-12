# frozen_string_literal: true

module YFantasy
  class Group
    class Standings < DependentSubresource
      # Required attributes
      option :teams, array_of(PickemTeam)
    end
  end
end
