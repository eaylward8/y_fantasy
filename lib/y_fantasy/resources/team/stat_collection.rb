# frozen_string_literal: true

module YFantasy
  class Team
    class StatCollection < DependentSubresource
      # Required attributes
      option :coverage_type
      option :stats, type: array_of(Stat)

      # Optional attributes
      option :season, optional: true, type: Types::Coercible::Integer


      # <team_remaining_games>
      #           <coverage_type>week</coverage_type>
      #           <week>4</week>
      #           <total>
      #               <remaining_games>0</remaining_games>
      #               <live_games>0</live_games>
      #               <completed_games>130</completed_games>
      #           </total>
      #       </team_remaining_games>
    end
  end
end
