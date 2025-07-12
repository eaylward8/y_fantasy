# frozen_string_literal: true

module YFantasy
  class Group
    class Settings < DependentSubresource
      # Required attributes
      option :start_week, type: Types::Coercible::Integer
      option :end_week, type: Types::Coercible::Integer
      option :max_strikes, type: Types::Coercible::Integer
      option :use_playoff_weeks, type: Types::Params::Bool
      option :deadline, type: Types::Coercible::Integer
      option :two_pick_start_week, type: Types::Coercible::Integer
      option :commissioner_note

      def deadline_desc
        if deadline == 1
          "5 minutes before the first game of each week"
        elsif deadline == 2
          "Sunday at 1:00 PM EST"
        end
      end
    end
  end
end
