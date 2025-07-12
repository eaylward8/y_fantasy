# frozen_string_literal: true

module YFantasy
  class PickemTeam
    class Pick < DependentSubresource
      # Required attributes
      option :team_key
      option :result
      option :locked, type: Types::Params::Bool

      def team
        Ref::Nfl.team(team_key)
      end
    end
  end
end
