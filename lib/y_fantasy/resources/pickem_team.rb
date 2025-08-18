# frozen_string_literal: true

module YFantasy
  # Represents a Yahoo Fantasy Pick'em Team in a NFL Survival Group
  class PickemTeam < BaseResource
    # --- REQUIRED ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] team_key
    # @return [String] The unique key for this PickemTeam
    option :team_key

    # @!attribute [r] team_id
    # @return [Integer] The ID for this PickemTeam
    option :team_id, type: Types::Coercible::Integer

    # @!attribute [r] name
    # @return [String] The name of the PickemTeam
    option :name

    # @!attribute [r] total_strikes
    # @return [Integer] The total number of strikes this team has
    option :total_strikes, type: Types::Coercible::Integer

    # @!attribute [r] elimination_week
    # @return [Integer] The week number when this team was eliminated
    option :elimination_week, type: Types::Coercible::Integer

    # --- OPTIONAL ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] can_edit_current_week
    # @return [Boolean, nil] whether picks are editable for the current week
    option :can_edit_current_week, optional: true, type: Types::Params::Bool

    # @!attribute [r] current_pick
    # @return [String, nil] the current pick for this team
    option :current_pick, optional: true

    # @!attribute [r] current_picks
    # @return [Array, nil] the current picks for this team
    option :current_picks, optional: true

    # @!attribute [r] eliminated
    # @return [Boolean, nil] whether this team has been eliminated
    option :eliminated, optional: true, type: Types::Params::Bool

    # @!attribute [r] elimination_pick
    # @return [String, nil] the pick that caused this team's elimination
    option :elimination_pick, optional: true

    # @!attribute [r] is_in_contest
    # @return [Boolean, nil] whether this team is in a contest
    option :is_in_contest, optional: true, type: Types::Params::Bool

    # @!attribute [r] is_owned_by_current_login
    # @return [Boolean, nil] whether this team is owned by the current user
    option :is_owned_by_current_login, optional: true, type: Types::Params::Bool

    # @!attribute [r] last_editable_week
    # @return [String, nil] the last week number that can be edited
    option :last_editable_week, optional: true

    # @!attribute [r] manager
    # @return [Team::Manager, nil] the manager of this PickemTeam
    option :manager, optional: true, type: instance_of(Team::Manager)

    # @!attribute [r] status
    # @return [String, nil] the status of this PickemTeam
    option :status, optional: true

    # --- SUBRESOURCES -------------------------------------------------------------------------------------------------

    # @!attribute [r] week_picks
    # @return [Array<WeekPick>, nil] the weekly picks for this team
    option :week_picks, optional: true, type: array_of(WeekPick)

    has_subresource :week_picks, klass: WeekPick

    # --- INSTANCE METHODS ---------------------------------------------------------------------------------------------

    # Returns the key of this PickemTeam
    # @return [String] the team key
    def key
      team_key
    end

    # Returns the group key for this PickemTeam
    # @return [String] the group key
    def group_key
      @group_key ||= team_key.sub(/\.t\.\d+/, "")
    end

    # Returns the group this PickemTeam belongs to
    # @return [Group] the group object
    def group
      @group ||= Group.find(group_key, with: :settings)
    end

    # Returns the week picks up to and including the group end week
    # For some reason, Yahoo's API can return more weeks than the group settings allow, and they are always strikes.
    # @return [Array<WeekPick>] the weekly picks for this team
    def true_week_picks
      @true_week_picks = week_picks.slice(0, group.settings.end_week)
    end

    # Returns the "true" total strikes, based on the group end week.
    # If the group allows two picks per week, fall back to `total_strikes` from the PickemTeam.
    # @return [Integer] the "true" total strikes for this team
    def true_total_strikes
      return total_strikes if group.settings.two_pick_start_week != 0

      strikes = true_week_picks.count { |wp| wp.picks.first.result == "strike" }
      return group.settings.max_strikes if strikes > group.settings.max_strikes

      strikes
    end
  end
end
