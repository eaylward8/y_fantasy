# frozen_string_literal: true

module YFantasy
  class DraftResult < DependentSubresource
    option :pick, type: Types::Coercible::Integer
    option :round, type: Types::Coercible::Integer
    option :player_key
    option :team_key

    def player
      self.class.find(:player, player_key)
    end

    def team
      self.class.find(:team, team_key)
    end
  end
end
