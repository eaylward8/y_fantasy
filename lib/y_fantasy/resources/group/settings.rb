# frozen_string_literal: true

module YFantasy
  class Group
    # Settings for a Yahoo NFL Survival Group
    class Settings < BaseSubresource
      DEADLINE_1_DESC = "5 minutes before the first game of each week"
      DEADLINE_2_DESC = "Sunday at 1:00 PM EST"

      # --- REQUIRED ATTRIBUTES ----------------------------------------------------------------------------------------

      # @!attribute [r] start_week
      # @return [Integer] the group start week
      option :start_week, type: Types::Coercible::Integer

      # @!attribute [r] end_week
      # @return [Integer] the group end week
      option :end_week, type: Types::Coercible::Integer

      # @!attribute [r] max_strikes
      # @return [Integer] the total number of strikes (incorrect picks) allowed
      option :max_strikes, type: Types::Coercible::Integer

      # @!attribute [r] use_playoff_weeks
      # @return [Boolean] whether or not the group uses playoff weeks
      option :use_playoff_weeks, type: Types::Params::Bool

      # @!attribute [r] deadline
      # @return [Integer]
      option :deadline, type: Types::Coercible::Integer

      # @!attribute [r] two_pick_start_week
      # @return [Integer]
      option :two_pick_start_week, type: Types::Coercible::Integer

      # @!attribute [r] commissioner_note
      # @return [String]
      option :commissioner_note

      # --- INSTANCE METHODS -------------------------------------------------------------------------------------------

      # :nocov:
      def deadline_desc
        if deadline == 1
          DEADLINE_1_DESC
        elsif deadline == 2
          DEADLINE_2_DESC
        end
      end
      # :nocov:
    end
  end
end
