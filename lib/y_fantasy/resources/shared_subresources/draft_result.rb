# frozen_string_literal: true

module YFantasy
  class DraftResult < DependentSubresource
    option :pick, type: Types::Coercible::Integer
    option :round, type: Types::Coercible::Integer
    option :team_key
    option :player_key
  end
end
