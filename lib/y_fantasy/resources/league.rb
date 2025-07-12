# frozen_string_literal: true

module YFantasy
  class League < BaseResource
    # Required attributes
    option :league_key
    option :league_id

    option :allow_add_to_dl_extra_pos, Types::Params::Bool
    option :draft_status
    option :edit_key
    option :end_date, type: Types::Params::Date
    option :felo_tier
    option :game_code
    option :is_cash_league, Types::Params::Bool
    option :is_pro_league, Types::Params::Bool
    option :league_type
    option :league_update_timestamp, Types::Coercible::Integer
    option :logo_url
    option :name
    option :num_teams, type: Types::Coercible::Integer
    option :renew
    option :renewed
    option :scoring_type
    option :season
    option :start_date, type: Types::Params::Date
    option :url
    option :weekly_deadline

    # Optional attributes
    option :short_invitation_url, optional: true
    option :current_week, optional: true, type: Types::Coercible::Integer
    option :start_week, optional: true, type: Types::Coercible::Integer
    option :end_week, optional: true, type: Types::Coercible::Integer
    option :is_finished, optional: true, type: Types::Params::Bool

    # Subresources
    option :draft_results, optional: true, type: array_of(DraftResult)
    option :players, optional: true, type: array_of(Player)
    option :scoreboard, optional: true, type: instance_of(Scoreboard)
    option :settings, optional: true, type: instance_of(Settings)
    option :standings, optional: true, type: instance_of(Standings)
    option :teams, optional: true, type: array_of(Team)

    has_subresource :draft_results, klass: DraftResult
    has_subresource :players, klass: Player
    has_subresource :scoreboard, klass: Scoreboard
    has_subresource :settings, klass: Settings
    has_subresource :standings, klass: Standings
    has_subresource :teams, klass: Team

    def started?
      Date.today >= start_date
    end

    def ended?
      is_finished || Date.today > end_date
    end

    def previous_league_key
      renew&.split("_")&.join(".l.")
    end

    def next_league_key
      renewed&.split("_")&.join(".l.")
    end

    def scoreboard_for_week(week)
      @scoreboard = self.class.find(league_key, with: :scoreboard, week: week).scoreboard
    end
  end
end
