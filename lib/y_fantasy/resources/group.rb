# frozen_string_literal: true

module YFantasy
  class Group < BaseResource
    # Required attributes
    option :group_key
    option :group_id
    option :name
    option :url
    option :type
    option :num_teams, type: Types::Coercible::Integer
    option :current_login_is_member, type: Types::Params::Bool
    option :current_week, type: Types::Coercible::Integer
    option :has_group_started, type: Types::Params::Bool
    option :current_week_lock_time, type: Types::Coercible::Integer

    # Optional attributes
    option :commissioner_nickname, optional: true
    option :is_commissioner, optional: true, type: Types::Params::Bool
  end
end
