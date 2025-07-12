# frozen_string_literal: true

module YFantasy
  class PickemTeam < BaseResource
    # Required attributes
    option :team_key
    option :team_id, type: Types::Coercible::Integer
    option :name
    option :total_strikes, type: Types::Coercible::Integer
    option :elimination_week, type: Types::Coercible::Integer

    # Optional attributes
    option :can_edit_current_week, optional: true, type: Types::Params::Bool
    option :current_pick, optional: true
    option :current_picks, optional: true
    option :eliminated, optional: true, type: Types::Params::Bool
    option :elimination_pick, optional: true
    option :is_in_contest, optional: true, type: Types::Params::Bool
    option :is_owned_by_current_login, optional: true, type: Types::Params::Bool
    option :last_editable_week, optional: true
    option :manager, optional: true, type: instance_of(Team::Manager)
    option :status, optional: true

    # Subresources
    option :week_picks, optional: true, type: array_of(WeekPick)

    has_subresource :week_picks, klass: WeekPick

    def group_key
      @group_key ||= team_key.sub(/\.t\.\d+/, "")
    end

    def group
      @group ||= Group.find(group_key)
    end
  end
end
