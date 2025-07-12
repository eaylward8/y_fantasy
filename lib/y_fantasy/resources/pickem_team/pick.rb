# frozen_string_literal: true

module YFantasy
  class PickemTeam
    class Pick < BaseSubresource
      # Required attributes
      option :team # Yahoo team key. E.g., "nfl.t.1".
      option :result
      option :locked, type: Types::Params::Bool

      def team_details
        Ref::Nfl.team(team)
      end
    end
  end
end
