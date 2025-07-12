# frozen_string_literal: true

module YFantasy
  # Represents a Yahoo Fantasy NFL Survival Group
  class Group < BaseResource
    # --- REQUIRED ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] group_key
    # @return [String] the unique key for this group
    option :group_key

    # @!attribute [r] group_id
    # @return [String] the ID for this group
    option :group_id

    # @!attribute [r] name
    # @return [String] the name of the group
    option :name

    # @!attribute [r] url
    # @return [String] the URL to the group's Yahoo Fantasy page
    option :url

    # @!attribute [r] type
    # @return [String] the type of group (e.g. "private")
    option :type

    # @!attribute [r] num_teams
    # @return [Integer] the number of teams in the group
    option :num_teams, type: Types::Coercible::Integer

    # @!attribute [r] current_login_is_member
    # @return [Boolean] whether the current user is a member of this group
    option :current_login_is_member, type: Types::Params::Bool

    # @!attribute [r] current_week
    # @return [Integer] the current week number of the group
    option :current_week, type: Types::Coercible::Integer

    # @!attribute [r] has_group_started
    # @return [Boolean] whether the group has started
    option :has_group_started, type: Types::Params::Bool

    # @!attribute [r] current_week_lock_time
    # @return [Integer] the timestamp when the current week locks
    option :current_week_lock_time, type: Types::Coercible::Integer

    # --- OPTIONAL ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] commissioner_nickname
    # @return [String, nil] the nickname of the commissioner
    option :commissioner_nickname, optional: true

    # @!attribute [r] is_commissioner
    # @return [Boolean, nil] whether the current user is the commissioner
    option :is_commissioner, optional: true, type: Types::Params::Bool

    # --- SUBRESOURCES --------------------------------------------------------------------------------

    # @!attribute [r] settings
    # @return [Settings, nil] the settings for this group
    option :settings, optional: true, type: instance_of(Settings)

    # @!attribute [r] standings
    # @return [Standings, nil] the standings for this group
    option :standings, optional: true, type: instance_of(Standings)

    # @!attribute [r] teams
    # @return [Array<PickemTeam>, nil] the teams in this group
    option :teams, optional: true, type: array_of(PickemTeam)

    has_subresource :settings, klass: Settings
    has_subresource :standings, klass: Standings
    has_subresource :teams, klass: PickemTeam
  end
end
