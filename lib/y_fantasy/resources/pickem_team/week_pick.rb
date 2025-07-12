# frozen_string_literal: true

module YFantasy
  class PickemTeam
    class WeekPick < DependentSubresource
      # Required attributes
      option :week, type: Types::Coercible::Integer
      option :picks_completed, type: Types::Coercible::Integer
      option :picks, type: array_of(Pick)

      def pick_details
        picks.compact.map(&:team_details)
      end
    end
  end
end
