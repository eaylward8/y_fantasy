# frozen_string_literal: true

module YFantasy
  class League
    class Standings < DependentSubresource
      # Required attributes
      option :teams
    end
  end
end
