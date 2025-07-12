# frozen_string_literal: true

module YFantasy
  class Group
    class Standings < BaseSubresource
      # Required attributes
      option :teams, array_of(PickemTeam)
    end
  end
end
