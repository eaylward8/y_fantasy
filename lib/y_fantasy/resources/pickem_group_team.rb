# frozen_string_literal: true

module YFantasy
  class PickemGroupTeam < BaseResource
    # Required attributes
    option :team_key
    option :team_id, type: Types::Coercible::Integer
    option :team_name
    option :total_strikes, type: Types::Coercible::Integer
    option :eliminated, type: Types::Params::Bool
    option :elimination_week, type: Types::Coercible::Integer
    option :elimination_pick
    option :current_pick
    option :current_picks

    # Optional attributes
    option :can_edit_current_week, optional: true, type: Types::Params::Bool
    option :is_in_contest, optional: true, type: Types::Params::Bool
    option :is_owned_by_current_login, optional: true, type: Types::Params::Bool
    option :last_editable_week, optional: true
    option :manager, type: instance_of(Team::Manager)
    option :status, optional: true


    # def manager
    #   managers.find { |manager| !manager.is_comanager }
    # end

    def group_key
      @group_key ||= team_key.sub(/\.t\.\d+/, "")
    end

    def group
      @group ||= Group.find(group_key)
    end
  end
end
