# frozen_string_literal: true

module YFantasy
  class StatWinner < BaseSubresource
    option :stat_id, type: Types::Coercible::Integer
    option :winner_team_key, optional: true
  end
end
