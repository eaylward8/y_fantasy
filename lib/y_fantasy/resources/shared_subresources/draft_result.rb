# frozen_string_literal: true

module YFantasy
  # Represents a single draft result in a Yahoo Fantasy league
  class DraftResult < BaseSubresource
    # --- REQUIRED ATTRIBUTES ------------------------------------------------------------------------------------------

    # @!attribute [r] pick
    # @return [Integer] the pick number
    option :pick, type: Types::Coercible::Integer

    # @!attribute [r] round
    # @return [Integer] the draft round
    option :round, type: Types::Coercible::Integer

    # @!attribute [r] player_key
    # @return [String] the unique key for the player drafted
    option :player_key

    # @!attribute [r] team_key
    # @return [String] the unique key for the drafting team
    option :team_key

    # :nocov:

    # Retrieves the Player resource associated with this draft result
    # @return [Player] the player drafted
    def player
      self.class.find(:player, player_key)
    end

    # Retrieves the Team resource associated with this draft result
    # @return [Team] the drafting team
    def team
      self.class.find(:team, team_key)
    end
    # :nocov:
  end
end
